//
//  GenresManager.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation

protocol IGenresManager: class {
    func getGenres(success: @escaping (_ response: GenresModel.Response) -> Void, failure: @escaping failureHandler)
}

class GenresManager: IGenresManager {
    func getGenres(success: @escaping (_ response: GenresModel.Response) -> Void, failure: @escaping failureHandler) {
        let model = GenresModel.Request()
        NetworkService.share.request(endpoint: Endpoint.genres(model: model)) { result in
            switch result {
            case .success(let response):
                success(GenresModel.Response(data: response))
            case .failure(let error):
                failure(error)
            }
        }
    }
}
