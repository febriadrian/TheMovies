//
//  GenresViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import RxCocoa
import RxSwift
import UIKit

protocol GenresDelegate {
    func didSelectGenres(genreIds: [String]?, selectedIndex: [IndexPath]?)
}

class GenresViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!

    var viewModel: IGenresViewModel?
    var router: IGenresRouter?
    var delegate: GenresDelegate?
    private var loadingView: LoadingView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setupParameters()
        setupComponent()
        setupBinding()
    }

    private func setupComponent() {
        title = "Genres"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))

        tableView.allowsMultipleSelection = true
        tableView.registerCellType(GenresTableViewCell.self)

        loadingView = LoadingView()
        loadingView.delegate = self
        loadingView.setup(in: contentView) {
            self.loadingView.start {
                self.viewModel?.getGenres()
            }
        }
    }

    private func setupBinding() {
        viewModel?.result
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    self.loadingView.stop()
                    DispatchQueue.main.async {
                        self.setupCurrentSelectedGenres()
                    }
                case .failure(let message):
                    self.loadingView.stop(isFailed: true, message: message)
                }
            })
            .disposed(by: disposeBag)

        viewModel?.genres
            .bind(to: tableView.rx.items(cellIdentifier: "GenresTableViewCell", cellType: GenresTableViewCell.self)) { _, genre, cell in
                cell.setupView(genre: genre)
            }
            .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                self.viewModel?.didSelectGenreId(at: indexPath.row)
                self.viewModel?.selectedIndex = self.tableView.indexPathsForSelectedRows
                self.setupRightBarButton()
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemDeselected
            .subscribe(onNext: { indexPath in
                self.viewModel?.didDeselectGenreId(at: indexPath.row)
                self.viewModel?.selectedIndex = self.tableView.indexPathsForSelectedRows
                self.setupRightBarButton()
            })
            .disposed(by: disposeBag)
    }

    private func setupRightBarButton() {
        if viewModel?.selectedCount == 0 {
            navigationItem.rightBarButtonItem = nil
            doneButton.isHidden = true
        } else {
            doneButton.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(didTapResetButton))
        }
    }

    private func setupCurrentSelectedGenres() {
        guard let indexPaths = viewModel?.selectedIndex else { return }
        viewModel?.selectedIndex?.removeAll()
        for indexPath in indexPaths {
            _ = tableView.delegate?.tableView?(tableView, willSelectRowAt: indexPath)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }

    @objc private func didTapResetButton() {
        guard let indexPaths = viewModel?.selectedIndex else { return }
        for indexPath in indexPaths {
            _ = tableView.delegate?.tableView?(tableView, willDeselectRowAt: indexPath)
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
        }

        delegate?.didSelectGenres(genreIds: nil, selectedIndex: nil)
        dismiss()
    }

    @objc private func didTapCancelButton() {
        dismiss()
    }

    @IBAction func didTapDoneButton(_ sender: UIButton) {
        delegate?.didSelectGenres(genreIds: viewModel?.genresIds, selectedIndex: viewModel?.selectedIndex)
        dismiss()
    }
}

extension GenresViewController: LoadingViewDelegate {
    func didTapReloadButton() {
        loadingView.start {
            self.viewModel?.getGenres()
        }
    }
}
