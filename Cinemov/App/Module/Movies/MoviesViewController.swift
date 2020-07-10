//
//  MoviesViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IMoviesViewController: class {
    var router: IMoviesRouter? { get set }

    func displayGetMovies(page: Int, totalResults: Int, movies: [MoviesModel.ViewModel])
    func displayGetMoviesFailed(message: String)
    func displayUpdateFavorite(movies: [MoviesModel.ViewModel])
}

class MoviesViewController: MoviesCollectionViewController {
    var interactor: IMoviesInteractor?
    var router: IMoviesRouter?
    var homeVC: HomeViewController?
    var category: MovieCategory?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }

    private func setupComponent() {
        homeVC = interactor?.parameters?["home"] as? HomeViewController
        category = interactor?.parameters?["category"] as? MovieCategory
    }

    override func xViewWillAppear() {
        homeVC?.homeDelegate = self
        if isInitialLoading {
            didTapReloadButton()
        } else {
            interactor?.updateFavorite(movies: movies)
        }
    }

    override func setupLayout() {
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
    }

    override func registerCellType() {
        collectionView.registerCellType(MovieCollectionViewCell.self)
    }

    override func getMovies() {
        guard let category = category else { return }
        interactor?.getMovies(category: category, page: page)
    }

    override func navToMovieDetail(id: Int) {
        router?.navToMovieDetail(id: id)
    }

    override func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MovieCollectionViewCell.self, for: indexPath)
        cell.movies = movies[indexPath.item]
        cell.handleFavorite = { [weak self] favorite in
            guard let movie = self?.movies[indexPath.row] else { return }
            Helper.updateFavorite(movie: movie, favorite: favorite) {
                collectionView.performBatchUpdates({
                    self?.movies[indexPath.row].favorite = !favorite
                    cell.movies = self?.movies[indexPath.row]
                })
            }
        }
        return cell
    }

    override func sizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }
}

extension MoviesViewController: IMoviesViewController {
    func displayGetMovies(page: Int, totalResults: Int, movies: [MoviesModel.ViewModel]) {
        displayMovies(page: page, totalResults: totalResults, movies: movies)
    }

    func displayGetMoviesFailed(message: String) {
        displayMoviesFailed(message: message)
    }

    func displayUpdateFavorite(movies: [MoviesModel.ViewModel]) {
        self.movies = movies
        collectionView.reloadData()
    }
}

extension MoviesViewController: HomeDelegate {
    func scrollToTop() {
        collectionViewScrollToTop()
    }
}
