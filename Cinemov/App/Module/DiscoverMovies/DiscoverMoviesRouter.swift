//
//  DiscoverMoviesRouter.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

protocol IDiscoverMoviesRouter: class {
    func navToMovieDetail(id: Int)
    func navToGenres(selectedIndex: [IndexPath]?)
}

class DiscoverMoviesRouter: IDiscoverMoviesRouter {
    weak var view: DiscoverMoviesViewController?

    init(view: DiscoverMoviesViewController?) {
        self.view = view
    }

    func navToMovieDetail(id: Int) {
        view?.navigate(type: .push, module: GeneralRoute.movieDetail(parameter: [
            "id": id
        ]), completion: nil)
    }

    func navToGenres(selectedIndex: [IndexPath]?) {
        view?.navigate(type: .presentWithNavigation, module: GeneralRoute.genres(parameter: [
            "selectedIndex": selectedIndex
        ]), completion: { controller in
            guard let module = controller as? GenresViewController else { return }
            module.delegate = self.view
        })
    }
}
