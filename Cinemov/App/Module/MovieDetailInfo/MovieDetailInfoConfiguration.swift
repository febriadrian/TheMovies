//
//  MovieDetailInfoConfiguration.swift
//  Cinemov
//
//  Created by Febri Adrian on 22/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation
import UIKit

struct MovieDetailInfoConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = MovieDetailInfoViewController()
        let router = MovieDetailInfoRouter(view: controller)
        let viewModel = MovieDetailInfoViewModel()
        let manager = MovieDetailInfoManager()

        viewModel.parameters = parameters
        viewModel.manager = manager
        controller.viewModel = viewModel
        controller.router = router
        return controller
    }
}
