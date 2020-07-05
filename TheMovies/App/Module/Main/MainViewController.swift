//
//  MainViewController.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
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

    var home: UIViewController!
    var discover: UIViewController!
    var mainVCDelegate: MainVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let parameter: [String: Any] = ["mainVC": self]

        home = HomeConfiguration.setup(parameters: parameter) as? HomeViewController
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)

        discover = DiscoverConfiguration.setup(parameters: parameter) as? DiscoverViewController
        discover.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(named: "discover"), tag: 1)

        viewControllers = [home, discover].map { UINavigationController(rootViewController: $0) }

        tabBar.tintColor = Colors.lightBlue
        delegate = self
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if selectedIndex == 0 || selectedIndex == 1 {
            mainVCDelegate?.scrollToTop()
        }
    }
}

extension MainViewController: IMainViewController {
    // do someting...
}
