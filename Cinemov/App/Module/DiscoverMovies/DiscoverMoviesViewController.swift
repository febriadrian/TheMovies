//
//  DiscoverMoviesViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class DiscoverMoviesViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: IDiscoverMoviesViewModel?
    var router: IDiscoverMoviesRouter?
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
        title = "Discover"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(navToGenres))

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)

        collectionView.delegate = self
        collectionView.registerCellType(DiscoverMoviesCollectionViewCell.self)
        collectionView.refreshControl = refreshControl

        loadingView = LoadingView()
        loadingView.delegate = self
        loadingView.setup(in: contentView) {
            self.loadingView.start {
                self.viewModel?.getMovies()
            }
        }
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
                    self.loadingView.start {
                        self.loadingView.stop(isFailed: true, message: message)
                    }
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
            .bind(to: collectionView.rx.items(cellIdentifier: "DiscoverMoviesCollectionViewCell", cellType: DiscoverMoviesCollectionViewCell.self)) { _, movie, cell in
                cell.setupView(movie: movie)
            }
            .disposed(by: disposeBag)

        collectionView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                guard let id = self.viewModel?.movieId(at: indexPath.item) else { return }
                self.router?.navToMovieDetail(id: id)
            })
            .disposed(by: disposeBag)

        collectionView.rx
            .willDisplayCell
            .subscribe(onNext: { _, indexPath in
                guard let vm = self.viewModel else { return }
                if vm.moviesCount > 0, vm.moviesCount < vm.totalResults, !vm.isLoadingMore, indexPath.item == vm.moviesCount - 1 {
                    vm.startLoadMore()
                }
            })
            .disposed(by: disposeBag)
    }

    @objc private func startRefreshing() {
        viewModel?.startRefreshing()
    }

    @objc private func navToGenres() {
        router?.navToGenres(selectedIndex: viewModel?.selectedIndex)
    }

    @objc private func didTapResetButton() {
        didSelectGenres(genreIds: nil, selectedIndex: nil)
        navigationItem.leftBarButtonItem = nil
    }
}

extension DiscoverMoviesViewController: LoadingViewDelegate {
    func didTapReloadButton() {
        loadingView.start {
            self.viewModel?.getMovies()
        }
    }
}

extension DiscoverMoviesViewController: GenresDelegate {
    func didSelectGenres(genreIds: [String]?, selectedIndex: [IndexPath]?) {
        viewModel?.didSelectGenres(genreIds: genreIds, selectedIndex: selectedIndex)

        if viewModel?.selectedIndex == nil {
            navigationItem.leftBarButtonItem = nil
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(didTapResetButton))
        }
    }
}

extension DiscoverMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collWidth = collectionView.frame.size.width
        return CGSize(width: collWidth / 3, height: collWidth / 3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel?.isLoadingMore == true {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 30)
    }
}

extension DiscoverMoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxContentOffset = scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom
        let currentContentOffset = scrollView.contentOffset.y

        guard currentContentOffset == maxContentOffset else { return }
        guard let vm = viewModel else { return }
        if vm.moviesCount > 0, vm.moviesCount < vm.totalResults, !vm.isLoadingMore {
            vm.startLoadMore()
        }
    }
}

extension DiscoverMoviesViewController: MainViewControllerDelegate {
    func scrollToTop() {
        guard collectionView.numberOfItems(inSection: 0) > 2, delegateCanScrollToTop else { return }
        collectionView.scrollToItem(at: [0, 0], at: .bottom, animated: true)
    }
}
