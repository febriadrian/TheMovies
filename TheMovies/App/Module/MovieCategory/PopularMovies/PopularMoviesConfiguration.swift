//
//  PopularMoviesConfiguration.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Foundation
import UIKit

class PopularMoviesConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = PopularMoviesViewController()
        let router = PopularMoviesRouter(view: controller)
        let presenter = PopularMoviesPresenter(view: controller)
        let manager = PopularMoviesManager()
        let interactor = PopularMoviesInteractor(presenter: presenter, manager: manager)

        controller.interactor = interactor
        controller.router = router
        interactor.parameters = parameters
        return controller
    }
}
