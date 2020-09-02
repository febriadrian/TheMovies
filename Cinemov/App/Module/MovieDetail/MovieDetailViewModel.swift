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

enum CreditsType {
    case cast
    case crew
}

protocol IMovieDetailViewModel: class {
    var parameters: [String: Any]? { get }
    var detail: PublishSubject<MovieDetailModel.MVDetailModel> { get }
    var cast: PublishSubject<[MovieDetailModel.PersonModel]> { get }
    var crew: PublishSubject<[MovieDetailModel.PersonModel]> { get }
    var trailers: PublishSubject<[MovieDetailModel.YoutubeTrailerModel]> { get }
    var result: PublishSubject<GeneralResult> { get }
    var favorite: PublishSubject<Bool> { get }
    var isInitialLoading: Bool { get }
    var id: Int? { get }
    var movieTitle: String { get }
    var trailersArray: [MovieDetailModel.YoutubeTrailerModel] { get }
    
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
    var trailers: PublishSubject<[MovieDetailModel.YoutubeTrailerModel]> = PublishSubject()
    var result: PublishSubject<GeneralResult> = PublishSubject()
    var favorite: PublishSubject<Bool> = PublishSubject()
    var detailValue: MovieDetailModel.MVDetailModel!
    var isInitialLoading: Bool = true
    var isFavorite: Bool = false
    var id: Int?
    var movieTitle: String = ""
    var trailersArray: [MovieDetailModel.YoutubeTrailerModel] = []
    
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
            
            let cast = self.setupPeopleViewModel(type: .cast, data: response.credits?.cast)
            self.cast.onNext(cast)
            
            let crew = self.setupPeopleViewModel(type: .crew, data: response.credits?.crew)
            self.crew.onNext(crew)
            
            self.trailersArray = self.setupTrailerViewModel(videos: response.videos)
            self.trailers.onNext(self.trailersArray)
            
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
    
    private func setupPeopleViewModel(type: CreditsType, data: [MovieDetailModel.Response.Credits.Detail]?) -> [MovieDetailModel.PersonModel] {
        guard let data = data else { return [] }
        var people = [MovieDetailModel.PersonModel]()
        
        for person in data {
            var profilePath: String?
            if let path = person.profilePath, !path.isEmpty {
                profilePath = ImageUrl.profile + path
            }
            
            switch type {
            case .cast:
                let cast = MovieDetailModel.PersonModel(
                    name: person.name ?? "n/a",
                    profilePath: profilePath ?? "",
                    character: person.character ?? "n/a",
                    job: ""
                )
                people.append(cast)
            case .crew:
                let crew = MovieDetailModel.PersonModel(
                    name: person.name ?? "n/a",
                    profilePath: profilePath ?? "",
                    character: "",
                    job: person.job ?? "n/a"
                )
                people.append(crew)
            }
        }
        
        return people
    }
    
    private func setupTrailerViewModel(videos: MovieDetailModel.Response.Videos?) -> [MovieDetailModel.YoutubeTrailerModel] {
        guard let videos = videos?.results else { return [] }
        var trailers = [MovieDetailModel.YoutubeTrailerModel]()
        
        for video in videos {
            if video.site?.lowercased() == "youtube", video.type?.lowercased() == "trailer" {
                let key = video.key ?? ""
                
                let videoUrl = URL(string: "https://www.youtube.com/watch?v=\(key)")
                let thumbnailUrl = "https://img.youtube.com/vi/\(key)/0.jpg"
                
                let trailer = MovieDetailModel.YoutubeTrailerModel(
                    videoUrl: videoUrl!,
                    thumbnailUrl: thumbnailUrl
                )
                
                trailers.append(trailer)
            }
        }
        
        return trailers
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
