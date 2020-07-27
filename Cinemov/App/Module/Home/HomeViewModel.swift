//
//  HomeViewModel.swift
//  Cinemov
//
//  Created by Febri Adrian on 21/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import Foundation
import RxCocoa
import RxSwift

protocol IHomeViewModel: class {
    var parameters: [String: Any]? { get }
    var mainViewController: MainViewController? { get }
    
    func setupParameters()
}

class HomeViewModel: IHomeViewModel {
    var parameters: [String: Any]?
    var manager: IHomeManager?
    var mainViewController: MainViewController?

    func setupParameters() {
        mainViewController = parameters?["mainvc"] as? MainViewController
    }
}
