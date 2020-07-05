//
//  HomeInteractor.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IHomeInteractor: class {
    var parameters: [String: Any]? { get set }

    func getMovies(category: MovieCategory, page: Int?)
}

class HomeInteractor: IHomeInteractor {
    var presenter: IHomePresenter?
    var manager: IHomeManager?
    var parameters: [String: Any]?

    init(presenter: IHomePresenter, manager: IHomeManager) {
        self.presenter = presenter
        self.manager = manager
    }

    func getMovies(category: MovieCategory, page: Int?) {
        manager?.getMovies(category: category, page: page, success: { response in
            let _response = HomeModel.Response(data: response)
            self.presenter?.presentGetMovies(response: _response)
        }, failure: { error in
            self.presenter?.presentGetMoviesFailed(error: error)
        })
    }
}
