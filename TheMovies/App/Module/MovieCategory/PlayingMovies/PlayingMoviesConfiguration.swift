//
//  PlayingMoviesConfiguration.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Foundation
import UIKit

class PlayingMoviesConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = PlayingMoviesViewController()
        let router = PlayingMoviesRouter(view: controller)
        let presenter = PlayingMoviesPresenter(view: controller)
        let manager = PlayingMoviesManager()
        let interactor = PlayingMoviesInteractor(presenter: presenter, manager: manager)

        controller.interactor = interactor
        controller.router = router
        interactor.parameters = parameters
        return controller
    }
}
