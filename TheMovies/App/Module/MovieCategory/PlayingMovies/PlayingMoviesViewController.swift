//
//  PlayingMoviesViewController.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IPlayingMoviesViewController: class {
    var router: IPlayingMoviesRouter? { get set }
}

class PlayingMoviesViewController: MovieCategoryViewController {
    var interactor: IPlayingMoviesInteractor?
    var router: IPlayingMoviesRouter?

    override func viewDidLoad() {
        super.viewDidLoad()
        homeVC = interactor?.parameters?["home"] as? HomeViewController
    }

    override func getMovies() {
        homeVC?.getMovies(category: .playing, page: page)
    }
    
    override func navToMovieDetail(id: Int, title: String) {
        router?.navToMovieDetail(id: id, title: title)
    }
}

extension PlayingMoviesViewController: IPlayingMoviesViewController {
    // do someting...
}
