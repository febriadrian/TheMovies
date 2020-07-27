//
//  FavoriteMoviesViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class FavoriteMoviesViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: IFavoriteMoviesViewModel?
    var router: IFavoriteMoviesRouter?
    private var refreshControl: UIRefreshControl!
    private var loadingView: LoadingView!
    private var delegateCanScrollToTop = false
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setupParameters()
        setupComponent()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.mainViewController?.mainViewControllerDelegate = self
        viewModel?.getMovies()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegateCanScrollToTop = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegateCanScrollToTop = false
    }

    private func setupComponent() {
        title = "Favorites"

        collectionView.delegate = self
        collectionView.registerCellType(HomeMoviesCollectionViewCell.self)
        collectionView.refreshControl = refreshControl

        loadingView = LoadingView()
        loadingView.delegate = self
        loadingView.setup(in: contentView)
        loadingView.reloadButton.setTitle("Discover Movies", for: .normal)
    }

    private func setupBinding() {
        viewModel?.result
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    self.loadingView.stop()
                case .failure(let message):
                    self.loadingView.start {
                        self.loadingView.stop(isFailed: true, message: message)
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel?.movies
            .bind(to: collectionView.rx.items(cellIdentifier: "HomeMoviesCollectionViewCell", cellType: HomeMoviesCollectionViewCell.self)) { index, movie, cell in
                cell.setupView(movie: movie)
                cell.handleFavorite = { [weak self] _ in
                    self?.viewModel?.removeFavorite(at: index)
                }
            }
            .disposed(by: disposeBag)

        collectionView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                guard let id = self.viewModel?.movieId(at: indexPath.item) else { return }
                self.router?.navToMovieDetail(id: id)
            }).disposed(by: disposeBag)
    }
}

extension FavoriteMoviesViewController: LoadingViewDelegate {
    func didTapReloadButton() {
        viewModel?.mainViewController?.selectedIndex = 1
    }
}

extension FavoriteMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }
}

extension FavoriteMoviesViewController: MainViewControllerDelegate {
    func scrollToTop() {
        guard collectionView.numberOfItems(inSection: 0) > 2, delegateCanScrollToTop else { return }
        collectionView.scrollToItem(at: [0, 0], at: .bottom, animated: true)
    }
}
