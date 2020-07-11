//
//  HomeViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

enum MovieCategory {
    case popular
    case playing
    case upcoming
    case toprated
}

protocol HomeDelegate {
    func scrollToTop()
}

protocol IHomeViewController: class {
    var router: IHomeRouter? { get set }
}

class HomeViewController: UIViewController {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingIndicatorConstraint: NSLayoutConstraint!
    @IBOutlet var menuButtons: [UIButton]!

    var interactor: IHomeInteractor?
    var router: IHomeRouter?

    var homeDelegate: HomeDelegate?
    var mainVC: MainViewController?
    var popularVC: MoviesViewController!
    var playingVC: MoviesViewController!
    var upcomingVC: MoviesViewController!
    var topRatedVC: MoviesViewController!

    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllerList: [UIViewController] = []
    var previousMenu: Int = 0
    var selectedIndex: Int = 0
    var shouldSelectControllerByScroll = true

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
        popularVC = MoviesConfiguration.setup(parameters: [
            "home": self,
            "category": MovieCategory.popular
        ]) as? MoviesViewController

        playingVC = MoviesConfiguration.setup(parameters: [
            "home": self,
            "category": MovieCategory.playing
        ]) as? MoviesViewController

        upcomingVC = MoviesConfiguration.setup(parameters: [
            "home": self,
            "category": MovieCategory.upcoming
        ]) as? MoviesViewController

        topRatedVC = MoviesConfiguration.setup(parameters: [
            "home": self,
            "category": MovieCategory.toprated
        ]) as? MoviesViewController

        viewControllerList = [popularVC, playingVC, upcomingVC, topRatedVC]

        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers(
            [viewControllerList[0]],
            direction: .forward,
            animated: true,
            completion: nil
        )

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

        for v in pageViewController.view.subviews {
            if v.isKind(of: UIScrollView.self) {
                (v as! UIScrollView).delegate = self as UIScrollViewDelegate
            }
        }
    }

    private func selectViewController(withIndex index: Int) {
        let viewController = viewControllerList[index]
        homeDelegate = viewController as? HomeDelegate

        pageViewController.setViewControllers(
            [viewController],
            direction: previousMenu > index ? .reverse : .forward,
            animated: true,
            completion: nil
        )

        previousMenu = index
    }

    private func selectMenuButtons(withTag tag: Int, completion: (() -> Void)? = nil) {
        menuButtons.forEach { button in
            if button.tag == tag {
                button.isSelected = true
            } else {
                button.isSelected = false
            }

            completion?()
        }
    }

    private func updateIndicatorViewPosition(menu: Int) {
        let width = view.bounds.width / 4
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.leadingIndicatorConstraint.constant = (width * CGFloat(menu))
                self.view.layoutIfNeeded()
            }) { _ in
                // do something
            }
        }
    }

    @IBAction func selectControllerByMenu(_ sender: UIButton) {
        shouldSelectControllerByScroll = selectedIndex == sender.tag ? true : false
        selectedIndex = sender.tag
        selectViewController(withIndex: sender.tag)
        selectMenuButtons(withTag: sender.tag) {
            self.updateIndicatorViewPosition(menu: sender.tag)
        }
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
                if let _ = menuButtons.filter({ $0.tag == index }).first {
                    selectedIndex = index
                    shouldSelectControllerByScroll = true
                    selectViewController(withIndex: index)
                    selectMenuButtons(withTag: index)
                }
            }
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldSelectControllerByScroll {
            let xOffset = scrollView.contentOffset.x
            let count = CGFloat(viewControllerList.count)
            let fullwidth = view.bounds.width
            let width = fullwidth / count
            let increment = CGFloat(selectedIndex) * width
            let constant = ((xOffset - fullwidth) / count) + increment

            guard constant > 0, constant <= fullwidth - width else { return }

            if xOffset > fullwidth {
                if constant <= increment {
                    leadingIndicatorConstraint.constant = increment
                } else {
                    leadingIndicatorConstraint.constant = constant
                }
            } else if xOffset < fullwidth {
                if constant >= increment {
                    leadingIndicatorConstraint.constant = increment
                } else {
                    leadingIndicatorConstraint.constant = constant
                }
            }
        }
    }
}

extension HomeViewController: MainVCDelegate {
    func scrollToTop() {
        homeDelegate?.scrollToTop()
    }
}

extension HomeViewController: IHomeViewController {
    // do someting...
}
