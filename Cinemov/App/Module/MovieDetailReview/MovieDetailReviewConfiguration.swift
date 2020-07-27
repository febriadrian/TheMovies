//
//  MovieDetailReviewConfiguration.swift
//  Cinemov
//
//  Created by Febri Adrian on 26/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation
import UIKit

struct MovieDetailReviewConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = MovieDetailReviewViewController()
        let router = MovieDetailReviewRouter(view: controller)
        let viewModel = MovieDetailReviewViewModel()
        let manager = MovieDetailReviewManager()

        viewModel.parameters = parameters
        viewModel.manager = manager
        controller.viewModel = viewModel
        controller.router = router
        return controller
    }
}
