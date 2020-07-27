//
//  HomeMoviesManager.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import SwiftyJSON

protocol IHomeMoviesManager: class {
    func getMovies(category: MovieCategory, page: Int?, success: @escaping (_ response: MoviesModel.Response) -> Void, failure: @escaping failureHandler)
}

class HomeMoviesManager: IHomeMoviesManager {
    func getMovies(category: MovieCategory, page: Int?, success: @escaping (_ response: MoviesModel.Response) -> Void, failure: @escaping failureHandler) {
        let model = MoviesModel.Request(page: page)
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

        NetworkService.share.request(endpoint: endpoint) { result in
            switch result {
            case .success(let response):
                success(MoviesModel.Response(data: response))
            case .failure(let error):
                failure(error)
            }
        }
    }
}
