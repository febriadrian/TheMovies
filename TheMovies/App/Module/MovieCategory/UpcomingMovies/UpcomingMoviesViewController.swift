//
//  UpcomingMoviesViewController.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IUpcomingMoviesViewController: class {
    var router: IUpcomingMoviesRouter? { get set }
}

class UpcomingMoviesViewController: MovieCategoryViewController {
    var interactor: IUpcomingMoviesInteractor?
    var router: IUpcomingMoviesRouter?

    override func viewDidLoad() {
        super.viewDidLoad()
        homeVC = interactor?.parameters?["home"] as? HomeViewController
    }

    override func getMovies() {
        homeVC?.getMovies(category: .upcoming, page: page)
    }
    
    override func navToMovieDetail(id: Int, title: String) {
        router?.navToMovieDetail(id: id, title: title)
    }
}

extension UpcomingMoviesViewController: IUpcomingMoviesViewController {
    // do someting...
}
