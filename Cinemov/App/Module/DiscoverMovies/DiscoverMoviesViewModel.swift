//
//  DiscoverMoviesViewModel.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol IDiscoverMoviesViewModel {
    var parameters: [String: Any]? { get }
    var mainViewController: MainViewController? { get }
    var movies: PublishSubject<[DiscoverMoviesModel.ViewModel]> { get }
    var result: PublishSubject<MoviesResult> { get }
    var moviesCount: Int { get }
    var totalResults: Int { get }
    var isInitialLoading: Bool { get }
    var isLoadingMore: Bool { get }
    var genreIds: [String]? { get set }
    var selectedIndex: [IndexPath]? { get set }

    func setupParameters()
    func getMovies()
    func startRefreshing()
    func startLoadMore()
    func movieId(at index: Int) -> Int
    func didSelectGenres(genreIds: [String]?, selectedIndex: [IndexPath]?)
}

class DiscoverMoviesViewModel: IDiscoverMoviesViewModel {
    var parameters: [String: Any]?
    var manager: IDiscoverMoviesManager?
    var mainViewController: MainViewController?
    var moviesArray = [DiscoverMoviesModel.ViewModel]()
    var movies: PublishSubject<[DiscoverMoviesModel.ViewModel]> = PublishSubject()
    var result: PublishSubject<MoviesResult> = PublishSubject()
    var page: Int = 1
    var totalResults: Int = 100
    var isInitialLoading: Bool = true
    var isRefreshing: Bool = false
    var isLoadingMore: Bool = false
    var genreIds: [String]?
    var selectedIndex: [IndexPath]?
    var selectedIds: String?

    func setupParameters() {
        mainViewController = parameters?["mainvc"] as? MainViewController
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

    func didSelectGenres(genreIds: [String]?, selectedIndex: [IndexPath]?) {
        self.genreIds = genreIds
        self.selectedIndex = selectedIndex

        if let genreIds = genreIds {
            selectedIds = Helper.arrayToString(genreIds)
        } else {
            selectedIds = nil
        }

        page = 1
        totalResults = 100
        getMovies()
    }

    func getMovies() {
        manager?.getMovies(genreIds: selectedIds, page: page, success: { response in
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

            if self.isLoadingMore {
                self.isLoadingMore = false
                let newMovies = results.map { DiscoverMoviesModel.ViewModel(movie: $0) }
                self.moviesArray += newMovies
                self.result.onNext(.successLoadMore)
            } else {
                self.moviesArray.removeAll()
                self.moviesArray = results.map { DiscoverMoviesModel.ViewModel(movie: $0) }

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
