//
//  MovieDetailConfiguration.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation
import UIKit

struct MovieDetailConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = MovieDetailViewController()
        let router = MovieDetailRouter(view: controller)
        let viewModel = MovieDetailViewModel()
        let manager = MovieDetailManager()

        viewModel.parameters = parameters
        viewModel.manager = manager
        controller.viewModel = viewModel
        controller.router = router
        return controller
    }
}
