//
//  Endpoint.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Alamofire
import Foundation

enum Endpoint {
    case popularMovies(model: HomeModel.Request)
    case playingMovies(model: HomeModel.Request)
    case upcomingMovies(model: HomeModel.Request)
    case topratedMovies(model: HomeModel.Request)
    case genres(model: GenresModel.Request)
    case discover(model: DiscoverModel.Request)
    case movieDetail(model: MovieDetailModel.Request)
}

extension Endpoint: IEndpoint {
    var method: HTTPMethod {
        switch self {
        case .popularMovies,
             .playingMovies,
             .upcomingMovies,
             .topratedMovies,
             .genres,
             .discover,
             .movieDetail:
            return .get
        }
    }

    var path: String {
        switch self {
        case .popularMovies:
            return API.baseUrl + "/movie/popular"
        case .playingMovies:
            return API.baseUrl + "/movie/now_playing"
        case .upcomingMovies:
            return API.baseUrl + "/movie/upcoming"
        case .topratedMovies:
            return API.baseUrl + "/movie/top_rated"
        case .genres:
            return API.baseUrl + "/genre/movie/list"
        case .discover:
            return API.baseUrl + "/discover/movie"
        case .movieDetail(let model):
            return API.baseUrl + "/movie/\(model.id)"
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
        case .genres(let model):
            return model.parameters()
        case .discover(let model):
            return model.parameters()
        case .movieDetail(let model):
            return model.parameters()
        }
    }

    var header: HTTPHeaders? {
        return [
            "Content-Type": "application/json"
        ]
    }

    var encoding: ParameterEncoding {
        switch self {
        case .popularMovies,
             .playingMovies,
             .upcomingMovies,
             .topratedMovies,
             .genres,
             .discover,
             .movieDetail:
            return URLEncoding.queryString
        }
    }
}
