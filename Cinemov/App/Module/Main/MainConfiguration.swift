//
//  MainConfiguration.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Foundation
import UIKit

class MainConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let controller = MainViewController()
        let router = MainRouter(view: controller)
        let presenter = MainPresenter(view: controller)
        let manager = MainManager()
        let interactor = MainInteractor(presenter: presenter, manager: manager)

        controller.interactor = interactor
        controller.router = router
        interactor.parameters = parameters
        return controller
    }
}
