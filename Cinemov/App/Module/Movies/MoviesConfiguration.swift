//
//  MoviesConfiguration.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Foundation
import UIKit

class MoviesConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = MoviesViewController()
        let router = MoviesRouter(view: controller)
        let presenter = MoviesPresenter(view: controller)
        let manager = MoviesManager()
        let interactor = MoviesInteractor(presenter: presenter, manager: manager)

        controller.interactor = interactor
        controller.router = router
        interactor.parameters = parameters
        return controller
    }
}