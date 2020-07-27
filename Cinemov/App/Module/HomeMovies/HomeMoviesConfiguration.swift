//
//  HomeMoviesConfiguration.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

struct HomeMoviesConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = HomeMoviesViewController()
        let router = HomeMoviesRouter(view: controller)
        let viewModel = HomeMoviesViewModel()
        let manager = HomeMoviesManager()

        viewModel.parameters = parameters
        viewModel.manager = manager
        controller.viewModel = viewModel
        controller.router = router
        return controller
    }
}
