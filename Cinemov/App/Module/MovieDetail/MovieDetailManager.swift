//
//  MovieDetailManager.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import SwiftyJSON

protocol IMovieDetailManager: class {
    func getMovieDetail(id: Int, success: @escaping successHandler, failure: @escaping failureHandler)
}

class MovieDetailManager: IMovieDetailManager {
    func getMovieDetail(id: Int, success: @escaping successHandler, failure: @escaping failureHandler) {
        let model = MovieDetailModel.Request(id: id)
        NetworkService.share.request(endpoint: Endpoint.movieDetail(model: model), success: { response in
            if let _response = response {
                success(JSON(_response))
            }
        }) { error in
            failure(error)
        }
    }
}
