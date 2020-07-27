//
//  GenresViewModel.swift
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

protocol IGenresViewModel: class {
    var parameters: [String: Any]? { get }
    var genres: PublishSubject<[GenresModel.ViewModel]> { get }
    var result: PublishSubject<GeneralResult> { get }
    var genresIds: [String] { get }
    var selectedCount: Int { get }
    var selectedIndex: [IndexPath]? { get set }

    func setupParameters()
    func getGenres()
    func didSelectGenreId(at index: Int)
    func didDeselectGenreId(at index: Int)
}

class GenresViewModel: IGenresViewModel {
    var parameters: [String: Any]?
    var manager: IGenresManager?
    var genresIds = [String]()
    var selectedIndex: [IndexPath]?
    var genresArray = [GenresModel.ViewModel]()
    var genres: PublishSubject<[GenresModel.ViewModel]> = PublishSubject()
    var result: PublishSubject<GeneralResult> = PublishSubject()

    var selectedCount: Int {
        return genresIds.count
    }

    func setupParameters() {
        selectedIndex = parameters?["selectedIndex"] as? [IndexPath]
    }

    func didSelectGenreId(at index: Int) {
        let id = "\(genresArray[index].id)"
        genresIds.append(id)
    }

    func didDeselectGenreId(at index: Int) {
        let id = "\(genresArray[index].id)"

        if let index = genresIds.firstIndex(of: id) {
            genresIds.remove(at: index)
        }
    }

    func getGenres() {
        genresArray = GenresDB.share.list()

        if genresArray.count == 0 {
            manager?.getGenres(success: { response in
                guard let results = response.genres, results.count > 0 else {
                    self.result.onNext(.failure(Messages.unknownError))
                    return
                }

                self.genresArray = results.map {
                    GenresModel.ViewModel(
                        id: $0.id ?? 0,
                        name: $0.name ?? ""
                    )
                }

                GenresDB.share.save(genres: self.genresArray)
                self.result.onNext(.success)
                self.genres.onNext(self.genresArray)
            }, failure: { error in
                if error != nil {
                    self.result.onNext(.failure(Messages.unknownError))
                } else {
                    self.result.onNext(.failure(Messages.noInternet))
                }
            })
        } else {
            result.onNext(.success)
            genres.onNext(genresArray)
        }
    }
}
