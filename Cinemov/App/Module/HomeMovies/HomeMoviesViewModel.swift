//
//  HomeMoviesViewModel.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol IHomeMoviesViewModel {
    var parameters: [String: Any]? { get }
    var homeViewController: HomeViewController? { get }
    var movies: PublishSubject<[MoviesModel.ViewModel]> { get }
    var result: PublishSubject<MoviesResult> { get }
    var moviesCount: Int { get }
    var totalResults: Int { get }
    var isInitialLoading: Bool { get }
    var isLoadingMore: Bool { get }

    func setupParameters()
    func getMovies()
    func startRefreshing()
    func startLoadMore()
    func movieId(at index: Int) -> Int
    func handleFavorite(favorite: Bool, index: Int)
    func updateFavorite()
}

class HomeMoviesViewModel: IHomeMoviesViewModel {
    var parameters: [String: Any]?
    var manager: IHomeMoviesManager?
    var homeViewController: HomeViewController?
    var category: MovieCategory?
    var moviesArray = [MoviesModel.ViewModel]()
    var movies: PublishSubject<[MoviesModel.ViewModel]> = PublishSubject()
    var result: PublishSubject<MoviesResult> = PublishSubject()
    var page: Int = 1
    var totalResults: Int = 100
    var isInitialLoading: Bool = true
    var isRefreshing: Bool = false
    var isLoadingMore: Bool = false

    func setupParameters() {
        homeViewController = parameters?["homevc"] as? HomeViewController
        category = parameters?["category"] as? MovieCategory
    }

    var moviesCount: Int {
        return moviesArray.count
    }

    func movieId(at index: Int) -> Int {
        guard index < moviesCount else { return 0 }
        return moviesArray[index].id
    }

    func startRefreshing() {
        isRefreshing = true
        page = 1
        totalResults = 100
        getMovies()
    }

    func startLoadMore() {
        isLoadingMore = true
        page += 1
        getMovies()
    }

    func handleFavorite(favorite: Bool, index: Int) {
        Helper.updateFavorite(movie: moviesArray[index], favorite: favorite) {
            self.moviesArray[index].favorite = !favorite
            self.movies.onNext(self.moviesArray)
        }
    }

    func updateFavorite() {
        for x in 0..<moviesArray.count {
            moviesArray[x].favorite = FavoriteDB.share.checkIsFavorite(id: moviesArray[x].id)
        }

        movies.onNext(moviesArray)
    }

    func getMovies() {
        guard let category = category else { return }
        manager?.getMovies(category: category, page: page, success: { response in
            self.page = response.page ?? 1
            self.totalResults = response.totalResults ?? 100

            guard let results = response.results, results.count > 0 else {
                if self.isLoadingMore {
                    self.isLoadingMore = false
                    let indexPath = IndexPath(item: self.moviesArray.count - 1, section: 0)
                    self.result.onNext(.failureLoadMore(Messages.noMovies, indexPath))
                } else if self.isRefreshing {
                    self.isRefreshing = false
                    self.result.onNext(.failureRefreshing(Messages.noMovies))
                } else {
                    self.result.onNext(.failureInitialLoading(Messages.noMovies))
                }
                return
            }

            var newMovies = [MoviesModel.ViewModel]()

            for x in results {
                var voteAverage: String?
                let path = x.posterPath ?? ""
                if let rating = x.voteAverage, rating != 0 {
                    voteAverage = "\(rating)"
                }

                let movie = MoviesModel.ViewModel(
                    id: x.id ?? 0,
                    title: x.title ?? "title is not available",
                    posterUrl: ImageUrl.poster + path,
                    voteAverage: voteAverage ?? "n/a",
                    overview: x.overview ?? "overview is not available",
                    releaseDate: Helper.dateFormatter(x.releaseDate),
                    favorite: FavoriteDB.share.checkIsFavorite(id: x.id ?? 0),
                    createdAt: 0
                )

                newMovies.append(movie)
            }

            if self.isLoadingMore {
                self.isLoadingMore = false
                self.moviesArray += newMovies
                self.result.onNext(.successLoadMore)
            } else {
                self.moviesArray.removeAll()
                self.moviesArray = newMovies

                if self.isRefreshing {
                    self.isRefreshing = false
                    self.result.onNext(.successRefreshing)
                } else {
                    self.isInitialLoading = false
                    self.result.onNext(.successInitialLoading)
                }
            }

            self.movies.onNext(self.moviesArray)
        }, failure: { error in
            var message = Messages.noInternet

            if error != nil {
                message = Messages.unknownError
            }

            if self.isLoadingMore {
                self.isLoadingMore = false
                self.page -= 1
                let msg = "Couldn't load more movies: \(message)"
                let indexPath = IndexPath(item: self.moviesArray.count - 1, section: 0)
                self.result.onNext(.failureLoadMore(msg, indexPath))
            } else if self.isRefreshing {
                self.isRefreshing = false
                self.result.onNext(.failureRefreshing(message))
            } else {
                self.isInitialLoading = false
                self.result.onNext(.failureInitialLoading(message))
            }
        })
    }
}
