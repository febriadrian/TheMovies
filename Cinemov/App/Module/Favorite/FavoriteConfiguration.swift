//
//  FavoriteConfiguration.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Foundation
import UIKit

class FavoriteConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = FavoriteViewController()
        let router = FavoriteRouter(view: controller)
        let presenter = FavoritePresenter(view: controller)
        let manager = FavoriteManager()
        let interactor = FavoriteInteractor(presenter: presenter, manager: manager)

        controller.interactor = interactor
        controller.router = router
        interactor.parameters = parameters
        return controller
    }
}
