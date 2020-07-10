//
//  DiscoverViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IDiscoverViewController: class {
    var router: IDiscoverRouter? { get set }

    func displayGetDiscoverMovies(page: Int, totalResults: Int, movies: [MoviesModel.ViewModel])
    func displayGetDiscoverMoviesFailed(message: String)
}

class DiscoverViewController: MoviesCollectionViewController {
    var interactor: IDiscoverInteractor?
    var router: IDiscoverRouter?
    var mainVC: MainViewController?
    var currentSelectedGenres: String?
    var currentSelectedIndex: [IndexPath]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }

    override func xViewWillAppear() {
        mainVC?.mainVCDelegate = self
        if isInitialLoading {
            didTapReloadButton()
        }
    }

    override func setupLayout() {
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
    }

    override func registerCellType() {
        collectionView.registerCellType(DiscoverCollectionViewCell.self)
    }

    override func getMovies() {
        interactor?.getDiscoverMovies(genreIds: currentSelectedGenres, page: page)
    }

    override func navToMovieDetail(id: Int) {
        router?.navToMovieDetail(id: id)
    }

    override func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DiscoverCollectionViewCell.self, for: indexPath)
        cell.movies = movies[indexPath.item]
        return cell
    }

    override func sizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collWidth: CGFloat = collectionView.frame.size.width
        let width = collWidth / 3
        return CGSize(width: width, height: width)
    }

    private func setupComponent() {
        title = "Discover"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(navToGenres))

        mainVC = interactor?.parameters?["mainVC"] as? MainViewController
    }

    private func showHideResetButton() {
        if currentSelectedIndex == nil {
            navigationItem.leftBarButtonItem = nil
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(didTapResetButton))
        }
    }

    @objc private func navToGenres() {
        router?.navToGenres(currentSelectedIndex: currentSelectedIndex)
    }

    @objc private func didTapResetButton() {
        didSelectGenres(genreIds: nil, selectedIndex: nil)
        navigationItem.leftBarButtonItem = nil
    }
}

extension DiscoverViewController: IDiscoverViewController {
    func displayGetDiscoverMovies(page: Int, totalResults: Int, movies: [MoviesModel.ViewModel]) {
        displayMovies(page: page, totalResults: totalResults, movies: movies)
    }

    func displayGetDiscoverMoviesFailed(message: String) {
        displayMoviesFailed(message: message)
    }
}

extension DiscoverViewController: GenresDelegate {
    func didSelectGenres(genreIds: [String]?, selectedIndex: [IndexPath]?) {
        if movies.count > 5, !collectionView.isHidden {
            collectionView.scrollToItem(at: [0, 0], at: .bottom, animated: true)
        }

        page = 1
        totalResults = 100
        currentSelectedIndex = selectedIndex

        if let genreIds = genreIds {
            currentSelectedGenres = Helper.arrayToString(genreIds)
        } else {
            currentSelectedGenres = nil
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.loadingView.start {
                self.showHideResetButton()
                self.getMovies()
            }
        }
    }
}

extension DiscoverViewController: MainVCDelegate {
    func scrollToTop() {
        collectionViewScrollToTop()
    }
}

extension DiscoverViewController {
    // do someting...
}

extension DiscoverViewController {
    // do someting...
}
