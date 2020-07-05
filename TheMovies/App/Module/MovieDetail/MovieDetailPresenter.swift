//
//  MovieDetailPresenter.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IMovieDetailPresenter: class {
    func presentGetMovieDetail(response: MovieDetailModel.Response)
    func presentGetMovieDetailFailed(error: Error?)
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
        var cast: [MovieDetailModel.PeopleModel]?
        var crew: [MovieDetailModel.PeopleModel]?
        
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
            backdropPath: response.backdropPath ?? "",
            posterPath: response.posterPath ?? ""
        )
        
        if let people = response.credits?.cast {
            for person in people {
                if cast == nil {
                    cast = [MovieDetailModel.PeopleModel]()
                }
                
                let x = MovieDetailModel.PeopleModel(
                    name: person.name ?? "n/a",
                    profilePath: person.profilePath ?? "",
                    character: person.character ?? "",
                    job: ""
                )
                cast?.append(x)
            }
        }
        
        if let people = response.credits?.crew {
            for person in people {
                if crew == nil {
                    crew = [MovieDetailModel.PeopleModel]()
                }
                
                let x = MovieDetailModel.PeopleModel(
                    name: person.name ?? "n/a",
                    profilePath: person.profilePath ?? "",
                    character: "",
                    job: person.job ?? "n/a"
                )
                crew?.append(x)
            }
        }
        
        var similar = [HomeModel.Movies]()
        var recommend = [HomeModel.Movies]()
        
        if let movies = response.similar?.results {
            similar = getSimilarMovies(movies)
        }
        
        if let movies = response.recommend?.results {
            recommend = getSimilarMovies(movies)
        }
        
        view?.displayGetMovieDetail(detail: detail, cast: cast, crew: crew, similar: similar, recommend: recommend)
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
    
    private func getSimilarMovies(_ results: [HomeModel.Response.Results]) -> [HomeModel.Movies] {
        var movies = [HomeModel.Movies]()
        
        for x in results {
            var rate: String?
            var date: String?
            
            if let rating = x.voteAverage, rating != 0 {
                rate = "\(rating)"
            }
            
            if let release = x.releaseDate {
                date = Helper.dateFormatter(release)
            }
            
            let path = x.posterPath ?? ""
            let posterUrl = API.imgBaseUrl + "w154" + path
            
            let movie = HomeModel.Movies(
                id: x.id ?? 0,
                title: x.title ?? "n/a",
                posterUrl: posterUrl,
                voteAverage: rate ?? "n/a",
                overview: x.overview ?? "n/a",
                releaseDate: date ?? "n/a"
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
}
