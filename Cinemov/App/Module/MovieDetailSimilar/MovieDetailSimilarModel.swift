//
//  MovieDetailSimilarModel.swift
//  Cinemov
//
//  Created by Febri Adrian on 26/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import SwiftyJSON

struct SimilarMoviesModel {
    struct Request {
        var id: Int

        func parameters() -> [String: Any]? {
            return [
                "api_key": Constant.apiKey,
                "page": 1,
                "language": "en-US"
            ]
        }
    }

    struct Response {
        // do something
    }

    struct ViewModel {
        // do something
    }
}
