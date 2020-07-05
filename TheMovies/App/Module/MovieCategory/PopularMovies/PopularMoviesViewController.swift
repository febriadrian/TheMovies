//
//  PopularMoviesViewController.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IPopularMoviesViewController: class {
    var router: IPopularMoviesRouter? { get set }
}

class PopularMoviesViewController: MovieCategoryViewController {
    var interactor: IPopularMoviesInteractor?
    var router: IPopularMoviesRouter?

    override func viewDidLoad() {
        super.viewDidLoad()
        homeVC = interactor?.parameters?["home"] as? HomeViewController
    }

    override func getMovies() {
        homeVC?.getMovies(category: .popular, page: page)
    }
    
    override func navToMovieDetail(id: Int, title: String) {
        router?.navToMovieDetail(id: id, title: title)
    }
}

extension PopularMoviesViewController: IPopularMoviesViewController {
    // do someting...
}
