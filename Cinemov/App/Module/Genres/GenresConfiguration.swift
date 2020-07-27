//
//  GenresConfiguration.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation
import UIKit

struct GenresConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = GenresViewController()
        let router = GenresRouter(view: controller)
        let viewModel = GenresViewModel()
        let manager = GenresManager()

        viewModel.parameters = parameters
        viewModel.manager = manager
        controller.viewModel = viewModel
        controller.router = router
        return controller
    }
}
