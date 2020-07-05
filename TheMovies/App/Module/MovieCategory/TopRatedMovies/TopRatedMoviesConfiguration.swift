//
//  TopRatedMoviesConfiguration.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Foundation
import UIKit

class TopRatedMoviesConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = TopRatedMoviesViewController()
        let router = TopRatedMoviesRouter(view: controller)
        let presenter = TopRatedMoviesPresenter(view: controller)
        let manager = TopRatedMoviesManager()
        let interactor = TopRatedMoviesInteractor(presenter: presenter, manager: manager)

        controller.interactor = interactor
        controller.router = router
        interactor.parameters = parameters
        return controller
    }
}
