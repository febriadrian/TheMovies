//
//  DiscoverInteractor.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IDiscoverInteractor: class {
    var parameters: [String: Any]? { get set }

    func getDiscoverMovies(genreIds: String?, page: Int?)
}

class DiscoverInteractor: IDiscoverInteractor {
    var presenter: IDiscoverPresenter?
    var manager: IDiscoverManager?
    var parameters: [String: Any]?

    init(presenter: IDiscoverPresenter, manager: IDiscoverManager) {
        self.presenter = presenter
        self.manager = manager
    }

    func getDiscoverMovies(genreIds: String?, page: Int?) {
        manager?.getDiscoverMovies(genreIds: genreIds, page: page, success: { response in
            let _response = HomeModel.Response(data: response)
            self.presenter?.presentGetDiscoverMovies(response: _response)
        }, failure: { error in
            self.presenter?.presentGetDiscoverMoviesFailed(error: error)
        })
    }
}
