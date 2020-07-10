//
//  MainViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IMainViewController: class {
    var router: IMainRouter? { get set }
}

protocol MainVCDelegate {
    func scrollToTop()
}

class MainViewController: UITabBarController {
    var interactor: IMainInteractor?
    var router: IMainRouter?
    var mainVCDelegate: MainVCDelegate?
    var home: UIViewController!
    var discover: UIViewController!
    var favorite: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let parameter: [String: Any] = ["mainVC": self]

        home = HomeConfiguration.setup(parameters: parameter) as? HomeViewController
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tab_home"), tag: 0)

        discover = DiscoverConfiguration.setup(parameters: parameter) as? DiscoverViewController
        discover.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(named: "tab_discover"), tag: 1)

        favorite = FavoriteConfiguration.setup(parameters: parameter) as? FavoriteViewController
        favorite.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "tab_favorite"), tag: 2)

        viewControllers = [home, discover, favorite].map { UINavigationController(rootViewController: $0) }

        tabBar.tintColor = Colors.lightBlue
        delegate = self
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        mainVCDelegate?.scrollToTop()
    }
}

extension MainViewController: IMainViewController {
    // do someting...
}
