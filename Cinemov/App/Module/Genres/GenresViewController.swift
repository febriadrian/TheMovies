//
//  GenresViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 09/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol GenresDelegate {
    func didSelectGenres(genreIds: [String]?, selectedIndex: [IndexPath]?)
}

protocol IGenresViewController: class {
    var router: IGenresRouter? { get set }
    
    func displayGetGenres(genres: [GenresModel.Response.Genres])
    func displayGetGenresFailed(message: String)
}

class GenresViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var interactor: IGenresInteractor?
    var router: IGenresRouter?
    var delegate: GenresDelegate?
    
    var loadingView: LoadingView!
    var genres = [GenresModel.Response.Genres]()
    var selectedGenres = [String]()
    var selectedIndex: [IndexPath]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }
    
    private func setupComponent() {
        title = "Genres"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
        
        selectedIndex = interactor?.parameters?["index"] as? [IndexPath]
        
        tableView.registerCellType(GenresTableViewCell.self)
        tableView.allowsMultipleSelection = true
        
        if let genres = GenresCache.share.get()?.data {
            self.genres = genres
            tableView.reloadData()
            setupCurrentSelectedGenres()
        } else {
            loadingView = LoadingView()
            loadingView.handleReload = { [weak self] in
                self?.didTapReloadButton()
            }
            
            loadingView.setup(in: contentView) {
                self.interactor?.getGenres()
            }
        }
    }
    
    private func setupCurrentSelectedGenres() {
        guard let indexPaths = selectedIndex else { return }
        
        selectedIndex?.removeAll()
        
        for indexPath in indexPaths {
            _ = tableView.delegate?.tableView?(tableView, willSelectRowAt: indexPath)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    
    private func setupRightBarButton() {
        if selectedGenres.count == 0 {
            navigationItem.rightBarButtonItem = nil
            doneButton.isHidden = true
        } else {
            doneButton.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(didTapResetButton))
        }
    }
    
    @objc private func didTapCancelButton() {
        dismiss()
    }
    
    @objc private func didTapResetButton() {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            let indexPath = IndexPath(row: row, section: 0)
            _ = tableView.delegate?.tableView?(tableView, willDeselectRowAt: indexPath)
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
        }
        
        selectedIndex = nil
        delegate?.didSelectGenres(genreIds: nil, selectedIndex: nil)
        dismiss()
    }
    
    @objc private func didTapReloadButton() {
        loadingView.start {
            self.interactor?.getGenres()
        }
    }
    
    @IBAction func didTapDoneButton(_ sender: UIButton) {
        delegate?.didSelectGenres(genreIds: selectedGenres, selectedIndex: selectedIndex)
        dismiss()
    }
}

extension GenresViewController: IGenresViewController {
    func displayGetGenres(genres: [GenresModel.Response.Genres]) {
        if genres.count == 0 {
            let message = "Something went wrong.."
            loadingView.stop(isSuccess: false, message: message)
        } else {
            loadingView.stop(isSuccess: true) {
                self.genres = genres
                self.tableView.reloadData()
                self.setupCurrentSelectedGenres()
            }
        }
    }
    
    func displayGetGenresFailed(message: String) {
        loadingView.stop(isSuccess: false, message: message)
    }
}

extension GenresViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GenresTableViewCell.self, for: indexPath)
        cell.genres = genres[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = genres[indexPath.row].id else { return }
        let stringId = "\(id)"
        
        if selectedIndex == nil {
            selectedIndex = [IndexPath]()
        }
        
        selectedGenres.append(stringId)
        selectedIndex?.append(indexPath)
        setupRightBarButton()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let id = genres[indexPath.row].id else { return }
        let stringId = "\(id)"
        
        if let index = selectedGenres.firstIndex(of: stringId) {
            selectedGenres.remove(at: index)
        }
        
        if let index = selectedIndex?.firstIndex(of: indexPath) {
            selectedIndex?.remove(at: index)
        }
        
        setupRightBarButton()
    }
}
