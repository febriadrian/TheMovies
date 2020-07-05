//
//  GenresManager.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import SwiftyJSON

protocol IGenresManager: class {
    func getGenres(success: @escaping successHandler, failure: @escaping failureHandler)
}

class GenresManager: IGenresManager {
    func getGenres(success: @escaping successHandler, failure: @escaping failureHandler) {
        let model = GenresModel.Request()
        NetworkService.share.request(endpoint: Endpoint.genres(model: model), success: { response in
            if let _response = response {
                success(JSON(_response))
            }
        }) { error in
            failure(error)
        }
    }
}
