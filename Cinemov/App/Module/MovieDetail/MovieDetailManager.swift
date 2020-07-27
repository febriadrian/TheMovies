//
//  MovieDetailManager.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation

protocol IMovieDetailManager: class {
    func getMovieDetail(id: Int, success: @escaping (_ response: MovieDetailModel.Response) -> Void, failure: @escaping failureHandler)
}

class MovieDetailManager: IMovieDetailManager {
    func getMovieDetail(id: Int, success: @escaping (_ response: MovieDetailModel.Response) -> Void, failure: @escaping failureHandler) {
        let model = MovieDetailModel.Request(id: id)
        NetworkService.share.request(endpoint: Endpoint.movieDetail(model: model)) { result in
            switch result {
            case .success(let response):
                success(MovieDetailModel.Response(data: response))
            case .failure(let error):
                failure(error)
            }
        }
    }
}
