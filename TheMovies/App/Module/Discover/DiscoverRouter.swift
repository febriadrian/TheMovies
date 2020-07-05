//
//  DiscoverRouter.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IDiscoverRouter: class {
    func navToGenres(currentSelectedIndex: [IndexPath]?)
    func navToMovieDetail(id: Int, title: String)
}

class DiscoverRouter: IDiscoverRouter {
    weak var view: DiscoverViewController?

    init(view: DiscoverViewController?) {
        self.view = view
    }

    func navToGenres(currentSelectedIndex: [IndexPath]?) {
        view?.navigate(type: .presentWithNavigation, module: GeneralRoute.genres(parameter: [
            "index": currentSelectedIndex
        ]), completion: { controller in
            guard let module = controller as? GenresViewController else { return }
            module.delegate = self.view
        })
    }

    func navToMovieDetail(id: Int, title: String) {
        view?.navigate(type: .push, module: GeneralRoute.movieDetail(parameter: [
            "id": id,
            "movieTitle": title
        ]), completion: nil)
    }
}
