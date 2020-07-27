//
//  MovieDetailSimilarViewModel.swift
//  Cinemov
//
//  Created by Febri Adrian on 26/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation
import RxCocoa
import RxSwift

protocol IMovieDetailSimilarViewModel: class {
    var parameters: [String: Any]? { get }
    var similarMovies: PublishSubject<[MoviesModel.ViewModel]> { get }
    var result: PublishSubject<GeneralResult> { get }
    var main: MovieDetailViewController? { get }
    var isInitialLoading: Bool { get }

    func setupParameters()
    func getSimilarMovies()
    func handleFavorite(favorite: Bool, index: Int)
    func updateFavorite()
    func movieId(at index: Int) -> Int
}

class MovieDetailSimilarViewModel: IMovieDetailSimilarViewModel {
    var parameters: [String: Any]?
    var manager: IMovieDetailSimilarManager?
    var similarMovies: PublishSubject<[MoviesModel.ViewModel]> = PublishSubject()
    var result: PublishSubject<GeneralResult> = PublishSubject()
    var moviesArray = [MoviesModel.ViewModel]()
    var main: MovieDetailViewController?
    var id: Int?
    var isInitialLoading: Bool = true

    func setupParameters() {
        id = parameters?["id"] as? Int
        main = parameters?["main"] as? MovieDetailViewController
    }

    func handleFavorite(favorite: Bool, index: Int) {
        Helper.updateFavorite(movie: moviesArray[index], favorite: favorite) {
            self.moviesArray[index].favorite = !favorite
            self.similarMovies.onNext(self.moviesArray)
        }
    }
    
    func updateFavorite() {
        for x in 0..<moviesArray.count {
            moviesArray[x].favorite = FavoriteDB.share.checkIsFavorite(id: moviesArray[x].id)
        }

        similarMovies.onNext(moviesArray)
    }

    func movieId(at index: Int) -> Int {
        guard index < moviesArray.count else { return 0 }
        return moviesArray[index].id
    }

    func getSimilarMovies() {
        guard let id = id else { return }
        manager?.getSimilarMovies(id: id, success: { response in
            guard let results = response.results, results.count > 0 else {
                self.result.onNext(.failure(Messages.noMovies))
                return
            }

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

                self.moviesArray.append(movie)
            }

            self.isInitialLoading = false
            self.result.onNext(.success)
            self.similarMovies.onNext(self.moviesArray)
        }, failure: { error in
            if error != nil {
                self.result.onNext(.failure(Messages.unknownError))
            } else {
                self.result.onNext(.failure(Messages.noInternet))
            }
        })
    }
}
