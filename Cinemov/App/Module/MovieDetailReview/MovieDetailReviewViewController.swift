//
//  MovieDetailReviewViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 26/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import RxCocoa
import RxSwift
import UIKit

class MovieDetailReviewViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var scrollDelegate: MovieDetailScrollDelegate?
    var viewModel: IMovieDetailReviewViewModel?
    var router: IMovieDetailReviewRouter?
    var loadingView: LoadingView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setupParameters()
        setupComponent()
        setupBinding()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.main?.shouldSelectControllerByScroll = true
    }

    private func setupComponent() {
        tableView.delegate = self
        tableView.registerCellType(ReviewTableViewCell.self)

        loadingView = LoadingView()
        loadingView.delegate = self
        loadingView.setup(in: contentView) {
            self.loadingView.start {
                self.viewModel?.getReviews()
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
                case .failure(let message):
                    self.loadingView.stop(isFailed: true, message: message)
                }
            })
            .disposed(by: disposeBag)

        viewModel?.reviews
            .bind(to: tableView.rx.items(cellIdentifier: "ReviewTableViewCell", cellType: ReviewTableViewCell.self)) { _, review, cell in
                cell.setupView(review: review)
                cell.handleUpdateCell = { [weak self] in
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
            }
            .disposed(by: disposeBag)
    }
}

extension MovieDetailReviewViewController: LoadingViewDelegate {
    func didTapReloadButton() {
        loadingView.start {
            self.viewModel?.getReviews()
        }
    }
}

extension MovieDetailReviewViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.didScroll(yOffset: scrollView.contentOffset.y)
    }
}

extension MovieDetailReviewViewController: UITableViewDelegate {
    //
}
