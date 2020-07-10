//
//  GenresInteractor.swift
//  Cinemov
//
//  Created by Febri Adrian on 09/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IGenresInteractor: class {
    var parameters: [String: Any]? { get set }

    func getGenres()
}

class GenresInteractor: IGenresInteractor {
    var presenter: IGenresPresenter?
    var manager: IGenresManager?
    var parameters: [String: Any]?

    init(presenter: IGenresPresenter, manager: IGenresManager) {
        self.presenter = presenter
        self.manager = manager
    }

    func getGenres() {
        manager?.getGenres(success: { response in
            let _response = GenresModel.Response(data: response)
            self.presenter?.presentGetGenres(response: _response)
        }, failure: { error in
            self.presenter?.presentGetGenresFailed(error: error)
        })
    }
}
