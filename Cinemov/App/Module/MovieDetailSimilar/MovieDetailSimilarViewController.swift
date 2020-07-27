//
//  MovieDetailSimilarViewController.swift
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

class MovieDetailSimilarViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var scrollDelegate: MovieDetailScrollDelegate?
    var viewModel: IMovieDetailSimilarViewModel?
    var router: IMovieDetailSimilarRouter?
    var loadingView: LoadingView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setupParameters()
        setupComponent()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel?.isInitialLoading == false {
            viewModel?.updateFavorite()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.main?.shouldSelectControllerByScroll = true
    }

    private func setupComponent() {
        collectionView.delegate = self
        collectionView.registerCellType(HomeMoviesCollectionViewCell.self)

        loadingView = LoadingView()
        loadingView.delegate = self
        loadingView.setup(in: contentView) {
            self.loadingView.start {
                self.viewModel?.getSimilarMovies()
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

        viewModel?.similarMovies
            .bind(to: collectionView.rx.items(cellIdentifier: "HomeMoviesCollectionViewCell", cellType: HomeMoviesCollectionViewCell.self)) { index, movie, cell in
                cell.setupView(movie: movie)
                cell.handleFavorite = { [weak self] favorite in
                    self?.viewModel?.handleFavorite(favorite: favorite, index: index)
                }
            }
            .disposed(by: disposeBag)

        collectionView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                guard let id = self.viewModel?.movieId(at: indexPath.item) else { return }
                self.router?.navToMovieDetail(id: id)
            })
            .disposed(by: disposeBag)
    }
}

extension MovieDetailSimilarViewController: LoadingViewDelegate {
    func didTapReloadButton() {
        loadingView.start {
            self.viewModel?.getSimilarMovies()
        }
    }
}

extension MovieDetailSimilarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }
}

extension MovieDetailSimilarViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.didScroll(yOffset: scrollView.contentOffset.y)
    }
}
