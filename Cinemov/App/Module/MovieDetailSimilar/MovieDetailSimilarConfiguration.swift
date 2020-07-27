//
//  MovieDetailSimilarConfiguration.swift
//  Cinemov
//
//  Created by Febri Adrian on 26/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation
import UIKit

struct MovieDetailSimilarConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = MovieDetailSimilarViewController()
        let router = MovieDetailSimilarRouter(view: controller)
        let viewModel = MovieDetailSimilarViewModel()
        let manager = MovieDetailSimilarManager()

        viewModel.parameters = parameters
        viewModel.manager = manager
        controller.viewModel = viewModel
        controller.router = router
        return controller
    }
}
