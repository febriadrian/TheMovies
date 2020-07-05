//
//  HomeManager.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import SwiftyJSON

protocol IHomeManager: class {
    func getMovies(category: MovieCategory, page: Int?, success: @escaping successHandler, failure: @escaping failureHandler)
}

class HomeManager: IHomeManager {
    func getMovies(category: MovieCategory, page: Int?, success: @escaping successHandler, failure: @escaping failureHandler) {
        let model = HomeModel.Request(page: page)
        var endpoint: Endpoint

        switch category {
        case .popular:
            endpoint = .popularMovies(model: model)
        case .playing:
            endpoint = .playingMovies(model: model)
        case .upcoming:
            endpoint = .upcomingMovies(model: model)
        case .toprated:
            endpoint = .topratedMovies(model: model)
        }

        NetworkService.share.request(endpoint: endpoint, success: { response in
            if let _response = response {
                success(JSON(_response))
            }
        }) { error in
            failure(error)
        }
    }
}
