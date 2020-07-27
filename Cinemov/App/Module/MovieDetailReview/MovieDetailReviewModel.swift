//
//  MovieDetailReviewModel.swift
//  Cinemov
//
//  Created by Febri Adrian on 26/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import SwiftyJSON

struct ReviewModel {
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
        var results: [Results]?

        init(data: JSON?) {
            if let items = data?["results"].array {
                self.results = items.map { Results(data: JSON($0.object)) }
            }
        }

        struct Results {
            var id: Int?
            var author: String?
            var content: String?

            init(data: JSON?) {
                self.id = data?["id"].int
                self.author = data?["author"].string
                self.content = data?["content"].string
            }
        }
    }

    struct ViewModel {
        private var review: Response.Results

        init(review: Response.Results) {
            self.review = review
        }

        var author: String {
            return review.author ?? "n/a"
        }

        var content: String {
            return review.content ?? "n/a"
        }
    }
}
