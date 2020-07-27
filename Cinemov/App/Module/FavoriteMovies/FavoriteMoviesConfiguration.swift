//
//  FavoriteMoviesConfiguration.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

struct FavoriteMoviesConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = FavoriteMoviesViewController()
        let router = FavoriteMoviesRouter(view: controller)
        let viewModel = FavoriteMoviesViewModel()
        let manager = FavoriteMoviesManager()

        viewModel.parameters = parameters
        viewModel.manager = manager
        controller.viewModel = viewModel
        controller.router = router
        return controller
    }
}
