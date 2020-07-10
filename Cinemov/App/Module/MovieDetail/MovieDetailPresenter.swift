//
//  MovieDetailPresenter.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IMovieDetailPresenter: class {
    func presentGetMovieDetail(response: MovieDetailModel.Response)
    func presentGetMovieDetailFailed(error: Error?)
    func presentUpdateFavorite(selfId: Int, similar: [MoviesModel.ViewModel])
}

class MovieDetailPresenter: IMovieDetailPresenter {
    weak var view: IMovieDetailViewController?

    init(view: IMovieDetailViewController?) {
        self.view = view
    }
    
    func presentGetMovieDetail(response: MovieDetailModel.Response) {
        var releaseDate: String?
        var runtime: String?
        var voteAverage: String?
        var budget: String?
        var revenue: String?
        var genres: String?
        var prodCompanies: String?
        var prodCountries: String?
        var posterPath: String?
        var backdropPath: String?
        var favorite: Bool?
        var cast = [MovieDetailModel.PeopleModel]()
        var crew = [MovieDetailModel.PeopleModel]()
        var similar = [MoviesModel.ViewModel]()
        var reviews = [MovieDetailModel.ReviewModel]()
        
        if let dateString = response.releaseDate {
            releaseDate = Helper.dateFormatter(dateString)
        }
        
        if let price = response.budget, price != 0 {
            budget = Helper.currencyFormatter(price: price)
        }
        
        if let price = response.revenue, price != 0 {
            revenue = Helper.currencyFormatter(price: price)
        }
        
        if let time = response.runtime {
            runtime = "\(time) minutes"
        }
        
        if let rating = response.voteAverage, rating != 0 {
            voteAverage = "\(rating)"
        }
        
        if let array = response.genres {
            genres = getString(from: array)
        }
        
        if let array = response.prodCompanies {
            prodCompanies = getString(from: array)
        }
        
        if let array = response.prodCountries {
            prodCountries = getString(from: array)
        }
        
        if let path = response.backdropPath, !path.isEmpty {
            backdropPath = ImageUrl.backdrop + path
        }
        
        if let path = response.posterPath, !path.isEmpty {
            posterPath = ImageUrl.poster + path
        }
        
        if let id = response.id {
            favorite = FavoriteDB.share.checkIsFavorite(id: id)
        }
        
        let detail = MovieDetailModel.MVDetailModel(
            id: response.id ?? 0,
            title: response.title ?? "n/a",
            originalTitle: response.originalTitle ?? "n/a",
            tagline: response.tagline ?? "n/a",
            overview: response.overview ?? "n/a",
            releaseDate: releaseDate ?? "n/a",
            homepage: response.homepage ?? "n/a",
            runtime: runtime ?? "n/a",
            budget: budget ?? "n/a",
            revenue: revenue ?? "n/a",
            voteAverage: voteAverage ?? "n/a",
            genres: genres ?? "n/a",
            prodCompanies: prodCompanies ?? "n/a",
            prodCountries: prodCountries ?? "n/a",
            backdropPath: backdropPath ?? "",
            posterPath: posterPath ?? "",
            favorite: favorite ?? false
        )
        
        if let people = response.credits?.cast {
            for person in people {
                var profilePath: String?
                if let path = person.profilePath, !path.isEmpty {
                    profilePath = ImageUrl.profile + path
                }
                
                let x = MovieDetailModel.PeopleModel(
                    name: person.name ?? "n/a",
                    profilePath: profilePath ?? "",
                    character: person.character ?? "",
                    job: ""
                )
                cast.append(x)
            }
        }
        
        if let people = response.credits?.crew {
            for person in people {
                var profilePath: String?
                if let path = person.profilePath, !path.isEmpty {
                    profilePath = ImageUrl.profile + path
                }
                
                let x = MovieDetailModel.PeopleModel(
                    name: person.name ?? "n/a",
                    profilePath: profilePath ?? "",
                    character: "",
                    job: person.job ?? "n/a"
                )
                crew.append(x)
            }
        }
        
        if let results = response.similar?.results {
            similar = getSimilarMovies(results)
        }
        
        if let results = response.reviews?.results {
            reviews = getReviews(results)
        }
        
        view?.displayGetMovieDetail(detail: detail, cast: cast, crew: crew, similar: similar, reviews: reviews)
    }
    
    private func getReviews(_ results: [MovieDetailModel.Response.Reviews.Results]) -> [MovieDetailModel.ReviewModel] {
        var reviews = [MovieDetailModel.ReviewModel]()
        
        for x in results {
            let author = x.author ?? "n/a"
            let content = x.content ?? "no review content found"
            let review = MovieDetailModel.ReviewModel(author: author, content: content)
            reviews.append(review)
        }
        
        return reviews
    }
    
    private func getSimilarMovies(_ results: [MoviesModel.Response.Results]) -> [MoviesModel.ViewModel] {
        var movies = [MoviesModel.ViewModel]()
        
        for x in results {
            var rate: String?
            var date: String?
            var favorite: Bool?
            
            if let rating = x.voteAverage, rating != 0 {
                rate = "\(rating)"
            }
            
            if let release = x.releaseDate {
                date = Helper.dateFormatter(release)
            }
            
            if let id = x.id {
                favorite = FavoriteDB.share.checkIsFavorite(id: id)
            }
            
            let path = x.posterPath ?? ""
            let posterUrl = ImageUrl.poster + path
            
            let movie = MoviesModel.ViewModel(
                id: x.id ?? 0,
                title: x.title ?? "n/a",
                posterUrl: posterUrl,
                voteAverage: rate ?? "n/a",
                overview: x.overview ?? "n/a",
                releaseDate: date ?? "n/a",
                favorite: favorite ?? false,
                createdAt: 0
            )
            
            movies.append(movie)
        }
        
        return movies
    }
    
    private func getString(from genresArr: [MovieDetailModel.Response.Others]) -> String? {
        var stringArr: [String]?
        
        for x in genresArr {
            if let name = x.name {
                if stringArr == nil {
                    stringArr = [String]()
                }
                
                stringArr?.append(name)
            }
        }
        
        return Helper.arrayToString(stringArr)
    }
    
    func presentGetMovieDetailFailed(error: Error?) {
        var message: String
        
        if NetworkStatus.isInternetAvailable {
            message = error?.localizedDescription ?? "Unknown Error"
        } else {
            message = "No Internet Connection"
        }
        
        view?.displayGetMovieDetailFailed(message: message)
    }
    
    func presentUpdateFavorite(selfId: Int, similar: [MoviesModel.ViewModel]) {
        let selfIsFavorite = FavoriteDB.share.checkIsFavorite(id: selfId)
        var newSimilar = [MoviesModel.ViewModel]()
        
        for x in similar {
            let favorite = FavoriteDB.share.checkIsFavorite(id: x.id)
            
            let movie = MoviesModel.ViewModel(
                id: x.id,
                title: x.title,
                posterUrl: x.posterUrl,
                voteAverage: x.voteAverage,
                overview: x.overview,
                releaseDate: x.releaseDate,
                favorite: favorite,
                createdAt: x.createdAt
            )
            
            newSimilar.append(movie)
        }
        
        view?.displayUpdateFavorite(selfIsFavorite: selfIsFavorite, similar: newSimilar)
    }
}
