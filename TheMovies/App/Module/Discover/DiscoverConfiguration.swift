//
//  DiscoverConfiguration.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Foundation
import UIKit

class DiscoverConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = DiscoverViewController()
        let router = DiscoverRouter(view: controller)
        let presenter = DiscoverPresenter(view: controller)
        let manager = DiscoverManager()
        let interactor = DiscoverInteractor(presenter: presenter, manager: manager)

        controller.interactor = interactor
        controller.router = router
        interactor.parameters = parameters
        return controller
    }
}
