//
//  GenresPresenter.swift
//  Cinemov
//
//  Created by Febri Adrian on 09/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IGenresPresenter: class {
    func presentGetGenres(response: GenresModel.Response)
    func presentGetGenresFailed(error: Error?)
}

class GenresPresenter: IGenresPresenter {
    weak var view: IGenresViewController?

    init(view: IGenresViewController?) {
        self.view = view
    }

    func presentGetGenres(response: GenresModel.Response) {
        if let genres = response.genres {
            GenresCache.share.set(data: genres)
            view?.displayGetGenres(genres: genres)
        } else {
            presentGetGenresFailed(error: nil)
        }
    }

    func presentGetGenresFailed(error: Error?) {
        var message: String

        if NetworkStatus.isInternetAvailable {
            message = error?.localizedDescription ?? "Unknown Error"
        } else {
            message = "No Internet Connection"
        }

        view?.displayGetGenresFailed(message: message)
    }
}
