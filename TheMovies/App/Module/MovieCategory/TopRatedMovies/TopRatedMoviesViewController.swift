//
//  TopRatedMoviesViewController.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol ITopRatedMoviesViewController: class {
    var router: ITopRatedMoviesRouter? { get set }
}

class TopRatedMoviesViewController: MovieCategoryViewController {
    var interactor: ITopRatedMoviesInteractor?
    var router: ITopRatedMoviesRouter?

    override func viewDidLoad() {
        super.viewDidLoad()
        homeVC = interactor?.parameters?["home"] as? HomeViewController
    }

    override func getMovies() {
        homeVC?.getMovies(category: .toprated, page: page)
    }
    
    override func navToMovieDetail(id: Int, title: String) {
        router?.navToMovieDetail(id: id, title: title)
    }
}

extension TopRatedMoviesViewController: ITopRatedMoviesViewController {
    // do someting...
}
