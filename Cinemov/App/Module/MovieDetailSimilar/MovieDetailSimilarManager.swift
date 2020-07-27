//
//  MovieDetailSimilarManager.swift
//  Cinemov
//
//  Created by Febri Adrian on 26/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation

protocol IMovieDetailSimilarManager: class {
    func getSimilarMovies(id: Int, success: @escaping (_ response: MoviesModel.Response) -> Void, failure: @escaping failureHandler)
}

class MovieDetailSimilarManager: IMovieDetailSimilarManager {
    func getSimilarMovies(id: Int, success: @escaping (_ response: MoviesModel.Response) -> Void, failure: @escaping failureHandler) {
        let model = SimilarMoviesModel.Request(id: id)
        NetworkService.share.request(endpoint: Endpoint.movieSimilar(model: model)) { result in
            switch result {
            case .success(let response):
                success(MoviesModel.Response(data: response))
            case .failure(let error):
                failure(error)
            }
        }
    }
}
