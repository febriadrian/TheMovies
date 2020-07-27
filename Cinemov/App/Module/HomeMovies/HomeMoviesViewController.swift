//
//  HomeMoviesViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol MovieDetailScrollDelegate {
    func didScroll(yOffset: CGFloat)
}

class HomeMoviesViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: IHomeMoviesViewModel?
    var router: IHomeMoviesRouter?
    private var refreshControl: UIRefreshControl!
    private var loadingView: LoadingView!
    private var delegateCanScrollToTop = false
    private let disposeBag = DisposeBag()

    var scrollDelegate: MovieDetailScrollDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setupParameters()
        setupComponent()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.homeViewController?.delegate = self

        if viewModel?.isInitialLoading == true {
            loadingView.start {
                self.viewModel?.getMovies()
            }
        } else {
            viewModel?.updateFavorite()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.homeViewController?.shouldSelectControllerByScroll = true
        delegateCanScrollToTop = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegateCanScrollToTop = false
    }

    private func setupComponent() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)

        collectionView.delegate = self
        collectionView.registerCellType(HomeMoviesCollectionViewCell.self)
        collectionView.refreshControl = refreshControl

        loadingView = LoadingView()
        loadingView.delegate = self
        loadingView.setup(in: contentView)
    }

    private func setupBinding() {
        viewModel?.result
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .successInitialLoading:
                    self.loadingView.stop()
                case .successRefreshing:
                    self.refreshControl.endRefreshing()
                case .successLoadMore:
                    print(".successLoadMore")
                case .failureInitialLoading(let message):
                    self.loadingView.stop(isFailed: true, message: message)
                case .failureRefreshing(let message):
                    Toast.share.show(message: message) {
                        self.refreshControl.endRefreshing()
                    }
                case .failureLoadMore(let message, let indexPath):
                    Toast.share.show(message: message) {
                        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel?.movies
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

    @objc private func startRefreshing() {
        viewModel?.startRefreshing()
    }
}

extension HomeMoviesViewController: LoadingViewDelegate {
    func didTapReloadButton() {
        loadingView.start {
            self.viewModel?.getMovies()
        }
    }
}

extension HomeMoviesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel?.isLoadingMore == true {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 30)
    }
}

extension HomeMoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxContentOffset = scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom
        let currentContentOffset = scrollView.contentOffset.y
        scrollDelegate?.didScroll(yOffset: currentContentOffset)

        guard currentContentOffset == maxContentOffset else { return }
        guard let vm = viewModel else { return }
        if vm.moviesCount > 0, vm.moviesCount < vm.totalResults, !vm.isLoadingMore {
            vm.startLoadMore()
        }
    }
}

extension HomeMoviesViewController: HomeViewControllerDelegate {
    func scrollToTop() {
        guard collectionView.numberOfItems(inSection: 0) > 2, delegateCanScrollToTop else { return }
        collectionView.scrollToItem(at: [0, 0], at: .bottom, animated: true)
    }
}
