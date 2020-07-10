//
//  FavoriteDB.swift
//  Cinemov
//
//  Created by Febri Adrian on 09/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteDB {
    static let share = FavoriteDB()
    private let realm = try! Realm()
    static var isUpdated = false

    func save(movie: MoviesModel.ViewModel) {
        let object = FavoriteObject()
        object.createdAt = Int(Date().timeIntervalSince1970)
        object.favorite = true
        object.id = movie.id
        object.title = movie.title
        object.posterUrl = movie.posterUrl
        object.voteAverage = movie.voteAverage
        object.overview = movie.overview
        object.releaseDate = movie.releaseDate

        try! realm.write {
            realm.add(object, update: .all)
        }
    }

    func list() -> [MoviesModel.ViewModel] {
        var favoriteMovies = [MoviesModel.ViewModel]()

        for x in load() {
            let movie = MoviesModel.ViewModel(
                id: x.id,
                title: x.title,
                posterUrl: x.posterUrl,
                voteAverage: x.voteAverage,
                overview: x.overview,
                releaseDate: x.releaseDate,
                favorite: x.favorite,
                createdAt: x.createdAt
            )
            favoriteMovies.append(movie)
        }

        favoriteMovies.sort(by: { (movie1, movie2) -> Bool in
            movie1.createdAt > movie2.createdAt
        })

        return favoriteMovies
    }

    func checkIsFavorite(id: Int) -> Bool {
        for x in load() {
            if x.id == id {
                return true
            }
        }
        return false
    }

    func remove(id: Int) {
        for x in load() {
            if x.id == id {
                try! realm.write {
                    realm.delete(x)
                }
            }
        }
    }

    func load() -> [FavoriteObject] {
        let results = realm.objects(FavoriteObject.self).toArray(ofType: FavoriteObject.self) as [FavoriteObject]
        return results
    }
}

class FavoriteObject: Object {
    @objc dynamic var createdAt: Int = 0
    @objc dynamic var favorite: Bool = false
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var posterUrl: String = ""
    @objc dynamic var voteAverage: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var releaseDate: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }
}
