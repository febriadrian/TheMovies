//
//  HomeViewController.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Kingfisher
import UIKit

protocol GetMoviesDelegate {
    func displayGetMovies(page: Int, totalResults: Int, movies: [HomeModel.Movies])
    func displayGetMoviesFailed(message: String)
    func scrollToTop()
}

protocol IHomeViewController: class {
    var router: IHomeRouter? { get set }
    
    func displayGetMovies(page: Int, totalResults: Int, movies: [HomeModel.Movies])
    func displayGetMoviesFailed(message: String)
}

class HomeViewController: UIViewController {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingIndicatorViewConstraint: NSLayoutConstraint!
    @IBOutlet var menuButtons: [UIButton]!
    
    var interactor: IHomeInteractor?
    var router: IHomeRouter?
    var mainVC: MainViewController?
    var getMoviesDelegate: GetMoviesDelegate?
    
    var popularMoviesVC: PopularMoviesViewController!
    var playingMoviesVC: PlayingMoviesViewController!
    var upcomingMoviesVC: UpcomingMoviesViewController!
    var topMoviesVC: TopRatedMoviesViewController!
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllerList: [UIViewController] = []
    var previousMenu: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "tmdblogo"))
        mainVC = interactor?.parameters?["mainVC"] as? MainViewController
        setupPageViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainVC?.mainVCDelegate = self
    }
    
    private func setupPageViewController() {
        let parameter: [String: Any] = ["home": self]
        
        popularMoviesVC = PopularMoviesConfiguration.setup(parameters: parameter) as? PopularMoviesViewController
        
        playingMoviesVC = PlayingMoviesConfiguration.setup(parameters: parameter) as? PlayingMoviesViewController
        
        upcomingMoviesVC = UpcomingMoviesConfiguration.setup(parameters: parameter) as? UpcomingMoviesViewController
        
        topMoviesVC = TopRatedMoviesConfiguration.setup(parameters: parameter) as? TopRatedMoviesViewController
        
        viewControllerList = [popularMoviesVC, playingMoviesVC, upcomingMoviesVC, topMoviesVC]
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers(
            [viewControllerList[0]],
            direction: .forward,
            animated: true,
            completion: nil)
        
        guard let pageView = pageViewController.view else { return }
        pageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageView)
        
        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: menuView.bottomAnchor),
            pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }
    
    private func updateIndicatorViewPosition(menu: Int) {
        let width = view.bounds.width / 4
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.leadingIndicatorViewConstraint.constant = (width * CGFloat(menu))
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func handleMenuSelection(_ sender: UIButton) {
        let viewController = viewControllerList[sender.tag]
        getMoviesDelegate = viewController as? GetMoviesDelegate
        
        pageViewController.setViewControllers(
            [viewController],
            direction: previousMenu > sender.tag ? .reverse : .forward,
            animated: true,
            completion: nil)
        
        previousMenu = sender.tag
        
        menuButtons.forEach { button in
            if button.tag == sender.tag {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
            updateIndicatorViewPosition(menu: sender.tag)
        }
    }
    
    func getMovies(category: MovieCategory, page: Int? = nil) {
        interactor?.getMovies(category: category, page: page)
    }
}

extension HomeViewController: IHomeViewController {
    func displayGetMovies(page: Int, totalResults: Int, movies: [HomeModel.Movies]) {
        getMoviesDelegate?.displayGetMovies(page: page, totalResults: totalResults, movies: movies)
    }
    
    func displayGetMoviesFailed(message: String) {
        getMoviesDelegate?.displayGetMoviesFailed(message: message)
    }
}

extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerList.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard viewControllerList.count > previousIndex else { return nil }
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else { return nil }
        guard viewControllerList.count > nextIndex else { return nil }
        return viewControllerList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
                let index = viewControllerList.firstIndex(of: currentViewController) {
                if let button = menuButtons.filter({ $0.tag == index }).first {
                    handleMenuSelection(button)
                }
            }
        }
    }
}

extension HomeViewController: MainVCDelegate {
    func scrollToTop() {
        getMoviesDelegate?.scrollToTop()
    }
}
