//
//  DiscoverMoviesManager.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol IDiscoverMoviesManager: class {
    func getMovies(genreIds: String?, page: Int?, success: @escaping (_ response: DiscoverMoviesModel.Response) -> Void, failure: @escaping failureHandler)
}

class DiscoverMoviesManager: IDiscoverMoviesManager {
    func getMovies(genreIds: String?, page: Int?, success: @escaping (_ response: DiscoverMoviesModel.Response) -> Void, failure: @escaping failureHandler) {
        let model = DiscoverMoviesModel.Request(genreIds: genreIds, page: page)
        NetworkService.share.request(endpoint: Endpoint.discover(model: model)) { result in
            switch result {
            case .success(let response):
                success(DiscoverMoviesModel.Response(data: response))
            case .failure(let error):
                failure(error)
            }
        }
    }
}
