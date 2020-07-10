//
//  Endpoint.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Alamofire
import Foundation

enum Endpoint {
    case popularMovies(model: MoviesModel.Request)
    case playingMovies(model: MoviesModel.Request)
    case upcomingMovies(model: MoviesModel.Request)
    case topratedMovies(model: MoviesModel.Request)
    case movieDetail(model: MovieDetailModel.Request)
    case genres(model: GenresModel.Request)
    case discover(model: DiscoverModel.Request)
}

extension Endpoint: IEndpoint {
    var method: HTTPMethod {
        switch self {
        case .popularMovies,
             .playingMovies,
             .upcomingMovies,
             .topratedMovies,
             .movieDetail,
             .genres,
             .discover:
            return .get
        }
    }

    var path: String {
        switch self {
        case .popularMovies:
            return Constant.apiBaseUrl + "/movie/popular"
        case .playingMovies:
            return Constant.apiBaseUrl + "/movie/now_playing"
        case .upcomingMovies:
            return Constant.apiBaseUrl + "/movie/upcoming"
        case .topratedMovies:
            return Constant.apiBaseUrl + "/movie/top_rated"
        case .movieDetail(let model):
            return Constant.apiBaseUrl + "/movie/\(model.id)"
        case .genres:
            return Constant.apiBaseUrl + "/genre/movie/list"
        case .discover:
            return Constant.apiBaseUrl + "/discover/movie"
        }
    }

    var parameter: Parameters? {
        switch self {
        case .popularMovies(let model):
            return model.parameters()
        case .playingMovies(let model):
            return model.parameters()
        case .upcomingMovies(let model):
            return model.parameters()
        case .topratedMovies(let model):
            return model.parameters()
        case .movieDetail(let model):
            return model.parameters()
        case .genres(let model):
            return model.parameters()
        case .discover(let model):
            return model.parameters()
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .popularMovies,
             .playingMovies,
             .upcomingMovies,
             .topratedMovies,
             .movieDetail,
             .genres,
             .discover:
            return URLEncoding.queryString
        }
    }

    var header: HTTPHeaders? {
        return [
            "Content-Type": "application/json",
//            "Cache-Control": "no-cache"
        ]
    }
}
