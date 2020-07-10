//
//  FavoriteInteractor.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IFavoriteInteractor: class {
    var parameters: [String: Any]? { get set }
}

class FavoriteInteractor: IFavoriteInteractor {
    var presenter: IFavoritePresenter?
    var manager: IFavoriteManager?
    var parameters: [String: Any]?

    init(presenter: IFavoritePresenter, manager: IFavoriteManager) {
        self.presenter = presenter
        self.manager = manager
    }
}
