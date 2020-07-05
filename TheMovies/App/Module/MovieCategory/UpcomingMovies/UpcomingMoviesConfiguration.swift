//
//  UpcomingMoviesConfiguration.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Foundation
import UIKit

class UpcomingMoviesConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = UpcomingMoviesViewController()
        let router = UpcomingMoviesRouter(view: controller)
        let presenter = UpcomingMoviesPresenter(view: controller)
        let manager = UpcomingMoviesManager()
        let interactor = UpcomingMoviesInteractor(presenter: presenter, manager: manager)

        controller.interactor = interactor
        controller.router = router
        interactor.parameters = parameters
        return controller
    }
}
