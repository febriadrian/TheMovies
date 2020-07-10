//
//  GenresCache.swift
//  Cinemov
//
//  Created by Febri Adrian on 09/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class GenresCache {
    static let share = GenresCache()

    private let key = "GenresCacheKey" as NSString
    private let cache = NSCache<NSString, Object>()

    func set(data: [GenresModel.Response.Genres]) {
        let viewModel = Object(data: data)
        cache.setObject(viewModel, forKey: key)
    }

    func get() -> Object? {
        let cacheObject = cache.object(forKey: key)
        return cacheObject
    }

    func remove() {
        cache.removeObject(forKey: key)
    }

    class Object {
        var data: [GenresModel.Response.Genres]?

        init(data: [GenresModel.Response.Genres]?) {
            self.data = data
        }
    }
}
