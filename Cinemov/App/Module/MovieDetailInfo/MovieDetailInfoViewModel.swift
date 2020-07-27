//
//  MovieDetailInfoViewModel.swift
//  Cinemov
//
//  Created by Febri Adrian on 22/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation
import RxCocoa
import RxSwift

protocol IMovieDetailInfoViewModel: class {
    var parameters: [String: Any]? { get }

    // do something
}

class MovieDetailInfoViewModel: IMovieDetailInfoViewModel {
    var parameters: [String: Any]?
    var manager: IMovieDetailInfoManager?

    // do something
}
