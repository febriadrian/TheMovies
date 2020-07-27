//
//  MovieDetailReviewManager.swift
//  Cinemov
//
//  Created by Febri Adrian on 26/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation

protocol IMovieDetailReviewManager: class {
    func getReviews(id: Int, success: @escaping (_ response: ReviewModel.Response) -> Void, failure: @escaping failureHandler)
}

class MovieDetailReviewManager: IMovieDetailReviewManager {
    func getReviews(id: Int, success: @escaping (_ response: ReviewModel.Response) -> Void, failure: @escaping failureHandler) {
        let model = ReviewModel.Request(id: id)
        NetworkService.share.request(endpoint: Endpoint.movieReviews(model: model)) { result in
            switch result {
            case .success(let response):
                success(ReviewModel.Response(data: response))
            case .failure(let error):
                failure(error)
            }
        }
    }
}
