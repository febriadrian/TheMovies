//
//  MovieDetailReviewViewModel.swift
//  Cinemov
//
//  Created by Febri Adrian on 26/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation
import RxCocoa
import RxSwift

protocol IMovieDetailReviewViewModel: class {
    var parameters: [String: Any]? { get }
    var reviews: PublishSubject<[ReviewModel.ViewModel]> { get }
    var result: PublishSubject<GeneralResult> { get }
    var main: MovieDetailViewController? { get }
    var id: Int? { get }

    func setupParameters()
    func getReviews()
}

class MovieDetailReviewViewModel: IMovieDetailReviewViewModel {
    var parameters: [String: Any]?
    var manager: IMovieDetailReviewManager?
    var reviews: PublishSubject<[ReviewModel.ViewModel]> = PublishSubject()
    var result: PublishSubject<GeneralResult> = PublishSubject()
    var main: MovieDetailViewController?
    var id: Int?

    func setupParameters() {
        id = parameters?["id"] as? Int
        main = parameters?["main"] as? MovieDetailViewController
    }

    func getReviews() {
        guard let id = id else { return }
        manager?.getReviews(id: id, success: { response in
            guard let results = response.results, results.count > 0 else {
                self.result.onNext(.failure("No Reviews Found"))
                return
            }

            let reviewArray = results.map { ReviewModel.ViewModel(review: $0) }
            self.result.onNext(.success)
            self.reviews.onNext(reviewArray)
        }, failure: { error in
            if error != nil {
                self.result.onNext(.failure(Messages.unknownError))
            } else {
                self.result.onNext(.failure(Messages.noInternet))
            }
        })
    }
}
