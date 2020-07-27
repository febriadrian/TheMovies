//
//  MovieDetailViewModel.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation
import RxCocoa
import RxSwift

protocol IMovieDetailViewModel: class {
    var parameters: [String: Any]? { get }
    var detail: PublishSubject<MovieDetailModel.MVDetailModel> { get }
    var cast: PublishSubject<[MovieDetailModel.PersonModel]> { get }
    var crew: PublishSubject<[MovieDetailModel.PersonModel]> { get }
    var result: PublishSubject<GeneralResult> { get }
    var favorite: PublishSubject<Bool> { get }
    var isInitialLoading: Bool { get }
    var id: Int? { get }
    var movieTitle: String { get }
    
    func setupParameters()
    func getMovieDetail()
    func updateFavorite()
}

class MovieDetailViewModel: IMovieDetailViewModel {
    var parameters: [String: Any]?
    var manager: IMovieDetailManager?
    var detail: PublishSubject<MovieDetailModel.MVDetailModel> = PublishSubject()
    var cast: PublishSubject<[MovieDetailModel.PersonModel]> = PublishSubject()
    var crew: PublishSubject<[MovieDetailModel.PersonModel]> = PublishSubject()
    var result: PublishSubject<GeneralResult> = PublishSubject()
    var favorite: PublishSubject<Bool> = PublishSubject()
    var detailValue: MovieDetailModel.MVDetailModel!
    var isInitialLoading: Bool = true
    var isFavorite: Bool = false
    var id: Int?
    var movieTitle: String = ""
    
    func setupParameters() {
        id = parameters?["id"] as? Int
    }
    
    func updateFavorite() {
        let movie = MoviesModel.ViewModel(
            id: detailValue.id,
            title: detailValue.title,
            posterUrl: detailValue.posterPath,
            voteAverage: detailValue.voteAverage,
            overview: detailValue.overview,
            releaseDate: detailValue.releaseDate,
            favorite: isFavorite,
            createdAt: 0
        )
        
        Helper.updateFavorite(movie: movie, favorite: isFavorite) {
            self.isFavorite.toggle()
            self.favorite.onNext(self.isFavorite)
        }
    }
    
    func getMovieDetail() {
        guard let id = id else { return }
        manager?.getMovieDetail(id: id, success: { response in
            
            self.detailValue = self.setupDetailViewModel(response: response)
            self.movieTitle = self.detailValue.title
            self.isFavorite = self.detailValue.favorite
            self.detail.onNext(self.detailValue)
            
            let cast = self.setupCastViewModel(response: response)
            self.cast.onNext(cast)
            
            let crew = self.setupCrewViewModel(response: response)
            self.crew.onNext(crew)
            
            self.result.onNext(.success)
        }, failure: { error in
            if error != nil {
                self.result.onNext(.failure(Messages.unknownError))
            } else {
                self.result.onNext(.failure(Messages.noInternet))
            }
        })
    }
    
    private func setupDetailViewModel(response: MovieDetailModel.Response) -> MovieDetailModel.MVDetailModel {
        var releaseDate: String?
        if let dateString = response.releaseDate {
            releaseDate = Helper.dateFormatter(dateString)
        }
        
        var budget: String?
        if let price = response.budget, price != 0 {
            budget = Helper.currencyFormatter(price: price)
        }
        
        var revenue: String?
        if let price = response.revenue, price != 0 {
            revenue = Helper.currencyFormatter(price: price)
        }
        
        var runtime: String?
        if let time = response.runtime {
            runtime = "\(time) minutes"
        }
        
        var voteAverage: String?
        if let rating = response.voteAverage, rating != 0 {
            voteAverage = "\(rating)"
        }
        
        var genres: String?
        if let array = response.genres {
            genres = getString(from: array)
        }
        
        var prodCompanies: String?
        if let array = response.prodCompanies {
            prodCompanies = getString(from: array)
        }
        
        var prodCountries: String?
        if let array = response.prodCountries {
            prodCountries = getString(from: array)
        }
        
        var backdropPath: String?
        if let path = response.backdropPath, !path.isEmpty {
            backdropPath = ImageUrl.backdrop + path
        }
        
        var posterPath: String?
        if let path = response.posterPath, !path.isEmpty {
            posterPath = ImageUrl.poster + path
        }
        
        let detail = MovieDetailModel.MVDetailModel(
            id: response.id ?? 0,
            title: response.title ?? "title is not available",
            originalTitle: response.originalTitle ?? "original title is not available",
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
            favorite: FavoriteDB.share.checkIsFavorite(id: response.id ?? 0)
        )
        
        return detail
    }
    
    private func setupCastViewModel(response: MovieDetailModel.Response) -> [MovieDetailModel.PersonModel] {
        guard let credits = response.credits?.cast else { return [] }
        var cast = [MovieDetailModel.PersonModel]()
        
        for person in credits {
            var profilePath: String?
            if let path = person.profilePath, !path.isEmpty {
                profilePath = ImageUrl.profile + path
            }
            
            let x = MovieDetailModel.PersonModel(
                name: person.name ?? "n/a",
                profilePath: profilePath ?? "",
                character: "",
                job: person.job ?? "n/a"
            )
            cast.append(x)
        }
        
        return cast
    }
    
    private func setupCrewViewModel(response: MovieDetailModel.Response) -> [MovieDetailModel.PersonModel] {
        guard let credits = response.credits?.crew else { return [] }
        var crew = [MovieDetailModel.PersonModel]()
        
        for person in credits {
            var profilePath: String?
            if let path = person.profilePath, !path.isEmpty {
                profilePath = ImageUrl.profile + path
            }
            
            let x = MovieDetailModel.PersonModel(
                name: person.name ?? "n/a",
                profilePath: profilePath ?? "",
                character: "",
                job: person.job ?? "n/a"
            )
            crew.append(x)
        }
        
        return crew
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
