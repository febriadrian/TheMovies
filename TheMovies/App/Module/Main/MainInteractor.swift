//
//  MainInteractor.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IMainInteractor: class {
    var parameters: [String: Any]? { get set }
}

class MainInteractor: IMainInteractor {
    var presenter: IMainPresenter?
    var manager: IMainManager?
    var parameters: [String: Any]?

    init(presenter: IMainPresenter, manager: IMainManager) {
        self.presenter = presenter
        self.manager = manager
    }
}
