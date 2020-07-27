//
//  FavoriteMoviesViewModel.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol IFavoriteMoviesViewModel {
    var parameters: [String: Any]? { get }
    var mainViewController: MainViewController? { get }
    var movies: PublishSubject<[MoviesModel.ViewModel]> { get }
    var result: PublishSubject<GeneralResult> { get }

    func setupParameters()
    func movieId(at index: Int) -> Int
    func removeFavorite(at index: Int)
    func getMovies()
}

class FavoriteMoviesViewModel: IFavoriteMoviesViewModel {
    var parameters: [String: Any]?
    var manager: IFavoriteMoviesManager?
    var mainViewController: MainViewController?
    var moviesArray = [MoviesModel.ViewModel]()
    var movies: PublishSubject<[MoviesModel.ViewModel]> = PublishSubject()
    var result: PublishSubject<GeneralResult> = PublishSubject()
    private let noFavoriteMovies = "You have no Favorite Movies.."

    func setupParameters() {
        mainViewController = parameters?["mainvc"] as? MainViewController
    }

    func movieId(at index: Int) -> Int {
        guard index < moviesArray.count else { return 0 }
        return moviesArray[index].id
    }

    func removeFavorite(at index: Int) {
        Helper.updateFavorite(movie: moviesArray[index], favorite: true) {
            self.moviesArray.remove(at: index)
            self.movies.onNext(self.moviesArray)
            if self.moviesArray.count == 0 {
                self.result.onNext(.failure(self.noFavoriteMovies))
            }
        }
    }

    func getMovies() {
        moviesArray = FavoriteDB.share.list()

        if moviesArray.count == 0 {
            result.onNext(.failure(noFavoriteMovies))
        } else {
            result.onNext(.success)
        }

        movies.onNext(moviesArray)
    }
}
