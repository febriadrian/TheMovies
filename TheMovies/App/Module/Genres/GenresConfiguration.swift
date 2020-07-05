//
//  GenresConfiguration.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Foundation
import UIKit

class GenresConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = GenresViewController()
        let router = GenresRouter(view: controller)
        let presenter = GenresPresenter(view: controller)
        let manager = GenresManager()
        let interactor = GenresInteractor(presenter: presenter, manager: manager)

        controller.interactor = interactor
        controller.router = router
        interactor.parameters = parameters
        return controller
    }
}
