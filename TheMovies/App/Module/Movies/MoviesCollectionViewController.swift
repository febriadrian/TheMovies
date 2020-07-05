//
//  MoviesCollectionViewController.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MoviesCollectionViewController: UIViewController {
    lazy var contentView: UIView = {
        let cv = UIView()
        return cv
    }()

    lazy var layout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.keyboardDismissMode = .onDrag
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.refreshControl = refreshControl
        return cv
    }()

    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)
        return rc
    }()

    lazy var loadingView: LoadingView = {
        let lv = LoadingView()
        return lv
    }()

    var loadMoreView: LoadMoreReusableView?
    var movies = [HomeModel.Movies]()

    var isInitialLoading = true
    var isLoadMore = false
    var delegateCanScrollToTop = false
    var page = 1
    var totalResults = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        registerCellType()
        setupConstraint()
        setupMainComponent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCommonDelegates()
        if isInitialLoading {
            didTapReloadButton()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegateCanScrollToTop = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegateCanScrollToTop = false
    }

    func setupLayout() {
        // override
    }

    func registerCellType() {
        // override
    }

    func getMovies() {
        // override
    }

    func setupCommonDelegates() {
        // override
    }

    func navToMovieDetail(id: Int, title: String) {
        // override
    }

    func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func sizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0, height: 0)
    }

    func displayMovies(page: Int, totalResults: Int, movies: [HomeModel.Movies]) {
        isInitialLoading = false

        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }

        self.page = page
        self.totalResults = totalResults

        if movies.count == 0 {
            let message = "No movies found.."
            loadingView.stop(isSuccess: false, message: message)
        } else {
            if isLoadMore {
                isLoadMore = false
                loadMoreView?.activityIndicator.isHidden = true
                loadMoreView?.activityIndicator.alpha = 0

                var indexPaths = [IndexPath]()

                for x in 0..<movies.count {
                    let indexPath: IndexPath = [0, self.movies.count + x]
                    indexPaths.append(indexPath)
                }

                self.movies += movies

                if #available(iOS 11.0, *) {
                    self.collectionView.performBatchUpdates({
                        self.collectionView.insertItems(at: indexPaths)
                    })
                } else {
                    collectionView.reloadData()
                }
            } else {
                self.movies = movies
                collectionView.reloadData()
                loadingView.stop(isSuccess: true)
            }
        }
    }

    func displayMoviesFailed(message: String) {
        if isLoadMore {
            isLoadMore = false
            Toast.share.show(message: message) {
                self.page -= 1
                self.collectionView.scrollToItem(at: [0, self.movies.count - 1], at: .bottom, animated: true)
            }
        } else {
            if refreshControl.isRefreshing {
                Toast.share.show(message: message) {
                    self.refreshControl.endRefreshing()
                }
            } else {
                isInitialLoading = false
                loadingView.stop(isSuccess: false, message: message)
            }
        }
    }

    func scrollToFirst() {
        if delegateCanScrollToTop, !collectionView.isHidden {
            if movies.count > 5 {
                collectionView.scrollToItem(at: [0, 0], at: .bottom, animated: true)
            }
        }
    }
}

extension MoviesCollectionViewController {
    private func setupMainComponent() {
        let loadMoreViewNib = UINib(nibName: "LoadMoreReusableView", bundle: nil)
        collectionView.register(loadMoreViewNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadMoreViewNib")

        loadingView.handleReload = { [weak self] in
            self?.didTapReloadButton()
        }

        loadingView.setup(in: contentView)
    }

    private func setupConstraint() {
        view.addSubview(contentView)
        contentView.addSubview(collectionView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentView.topAnchor.constraint(equalTo: margins.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),

            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @objc private func startRefreshing() {
        page = 1
        getMovies()
    }

    @objc private func didTapReloadButton() {
        loadingView.start {
            self.getMovies()
        }
    }

    private func startLoadMore() {
        isLoadMore = true
        page += 1
        loadMoreView?.activityIndicator.alpha = 1
        loadMoreView?.activityIndicator.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.getMovies()
        }
    }
}

extension MoviesCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cellForItemAt(collectionView, cellForItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sizeForItemAt(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = movies[indexPath.item].id
        let title = movies[indexPath.item].title
        navToMovieDetail(id: id, title: title)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if movies.count > 0, movies.count < totalResults {
            if indexPath.item == movies.count - 1, !isLoadMore {
                startLoadMore()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoadMore {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 30)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadMoreViewNib", for: indexPath) as! LoadMoreReusableView
            loadMoreView = aFooterView
            loadMoreView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            loadMoreView?.activityIndicator.startAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            loadMoreView?.activityIndicator.stopAnimating()
        }
    }
}

extension MoviesCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxContentOffset = scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom
        let currentContentOffset = scrollView.contentOffset.y

        if currentContentOffset == maxContentOffset, !isLoadMore {
            if movies.count > 0, movies.count < totalResults {
                startLoadMore()
            }
        }
    }
}