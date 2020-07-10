//
//  GeneralRoute.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Foundation
import UIKit

enum GeneralRoute: IRouter {
    case main
    case home
    case discover
    case favorite
    case movieDetail(parameter: [String: Any])
    case genres(parameter: [String: Any?])
}

extension GeneralRoute {
    var module: UIViewController? {
        switch self {
        case .main:
            return MainConfiguration.setup()
        case .home:
            return HomeConfiguration.setup()
        case .discover:
            return DiscoverConfiguration.setup()
        case .favorite:
            return FavoriteConfiguration.setup()
        case .movieDetail(let parameter):
            return MovieDetailConfiguration.setup(parameters: parameter)
        case .genres(let parameter):
            return GenresConfiguration.setup(parameters: parameter as [String: Any])
        }
    }
}
