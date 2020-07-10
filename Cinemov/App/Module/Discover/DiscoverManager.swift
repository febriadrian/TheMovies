//
//  DiscoverManager.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import SwiftyJSON

protocol IDiscoverManager: class {
    func getDiscoverMovies(genreIds: String?, page: Int?, success: @escaping successHandler, failure: @escaping failureHandler)
}

class DiscoverManager: IDiscoverManager {
    func getDiscoverMovies(genreIds: String?, page: Int?, success: @escaping successHandler, failure: @escaping failureHandler) {
        let model = DiscoverModel.Request(genreIds: genreIds, page: page)
        NetworkService.share.request(endpoint: Endpoint.discover(model: model), success: { response in
            if let _response = response {
                success(JSON(_response))
            }
        }) { error in
            failure(error)
        }
    }
}
