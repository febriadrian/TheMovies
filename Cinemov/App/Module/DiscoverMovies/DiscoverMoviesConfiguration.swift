//
//  DiscoverMoviesConfiguration.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

struct DiscoverMoviesConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = DiscoverMoviesViewController()
        let router = DiscoverMoviesRouter(view: controller)
        let viewModel = DiscoverMoviesViewModel()
        let manager = DiscoverMoviesManager()
        
        viewModel.parameters = parameters
        viewModel.manager = manager
        controller.viewModel = viewModel
        controller.router = router
        return controller
    }
}
