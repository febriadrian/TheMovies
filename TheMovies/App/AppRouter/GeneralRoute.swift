//
//  GeneralRoute.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
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
    case popularMovies
    case playingMovies
    case upcomingMovies
    case topMovies
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
            case .popularMovies:
                return PopularMoviesConfiguration.setup()
            case .playingMovies:
                return PlayingMoviesConfiguration.setup()
            case .upcomingMovies:
                return UpcomingMoviesConfiguration.setup()
            case .topMovies:
                return TopRatedMoviesConfiguration.setup()
            case .movieDetail(let parameter):
                return MovieDetailConfiguration.setup(parameters: parameter)
            case .genres(let parameter):
                return GenresConfiguration.setup(parameters: parameter as [String : Any])
        }
    }
}
