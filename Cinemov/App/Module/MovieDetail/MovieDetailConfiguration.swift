//
//  MovieDetailConfiguration.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Foundation
import UIKit

class MovieDetailConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = MovieDetailViewController()
        let router = MovieDetailRouter(view: controller)
        let presenter = MovieDetailPresenter(view: controller)
        let manager = MovieDetailManager()
        let interactor = MovieDetailInteractor(presenter: presenter, manager: manager)

        controller.interactor = interactor
        controller.router = router
        interactor.parameters = parameters
        return controller
    }
}
