//
//  MovieDetailViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import RxCocoa
import RxSwift
import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingIndicatorConstraint: NSLayoutConstraint!
    @IBOutlet var menuButtons: [UIButton]!
    @IBOutlet weak var topBarsView: UIView!
    @IBOutlet weak var topBarsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var posterTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var posterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!

    var infoVC: MovieDetailInfoViewController!
    var similarVC: MovieDetailSimilarViewController!
    var reviewVC: MovieDetailReviewViewController!
    var viewModel: IMovieDetailViewModel?
    var router: IMovieDetailRouter?
    private let disposeBag = DisposeBag()
    private var loadingView: LoadingView!

    var topBarsHeight: CGFloat = 0
    var normalViewTopConstraint: CGFloat = 0
    var currentYOffset: CGFloat = 0
    private var shouldShowTopBarsView = false

    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllerList: [UIViewController] = []
    var previousMenu: Int = 0
    var selectedIndex: Int = 0
    var screenWidth: CGFloat = 0
    var menuCount: CGFloat = 0
    var indicatorWidth: CGFloat = 0
    var shouldSelectControllerByScroll = true
    var shouldSelectControllerByMenu = true

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setupParameters()
        setupPageViewController()
        setupComponent()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !shouldShowTopBarsView {
            shouldShowTopBarsView = true
        }
    }

    private func setupPageViewController() {
        let parameter: [String: Any] = ["id": viewModel?.id ?? 0, "main": self]

        infoVC = MovieDetailInfoConfiguration.setup(parameters: parameter) as? MovieDetailInfoViewController
        infoVC.scrollDelegate = self

        similarVC = MovieDetailSimilarConfiguration.setup(parameters: parameter) as? MovieDetailSimilarViewController
        similarVC.scrollDelegate = self

        reviewVC = MovieDetailReviewConfiguration.setup(parameters: parameter) as? MovieDetailReviewViewController
        reviewVC.scrollDelegate = self

        viewControllerList = [infoVC, similarVC, reviewVC]
        menuCount = CGFloat(viewControllerList.count)
        indicatorWidth = screenWidth / menuCount

        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers(
            [viewControllerList[0]],
            direction: .forward,
            animated: true,
            completion: nil
        )

        guard let pageView = pageViewController.view else { return }
        pageViewController.view?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageView)

        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: menuView.bottomAnchor),
            pageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        addChild(pageViewController)
        pageViewController.didMove(toParent: self)

        for v in pageViewController.view.subviews {
            if v.isKind(of: UIScrollView.self) {
                (v as! UIScrollView).delegate = self as UIScrollViewDelegate
            }
        }
    }

    private func setupComponent() {
        scrollView.delegate = self

        extendedLayoutIncludesOpaqueBars = true
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0

        topBarsHeight = statusBarHeight + navBarHeight
        scrollView.contentInset = UIEdgeInsets(top: -topBarsHeight, left: 0, bottom: 0, right: 0)
        topBarsHeightConstraint.constant = topBarsHeight
        posterTopConstraint.constant += topBarsHeight
        normalViewTopConstraint = posterHeightConstraint.constant + posterTopConstraint.constant + 12
        menuViewTopConstraint.constant = normalViewTopConstraint

        screenWidth = UIScreen.main.bounds.width
        indicatorWidth = screenWidth / CGFloat(menuButtons.count)

        loadingView = LoadingView()
        loadingView.delegate = self
        loadingView.setup(in: contentView)
        loadingView.start {
            self.viewModel?.getMovieDetail()
        }

        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
    }

    private func setupBinding() {
        viewModel?.result
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    self.loadingView.stop()
                case .failure(let message):
                    self.loadingView.stop(isFailed: true, message: message)
                }
            })
            .disposed(by: disposeBag)

        viewModel?.favorite
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { isFavorite in
                self.favoriteButton.isSelected = isFavorite
            })
            .disposed(by: disposeBag)

        viewModel?.detail
            .bind(onNext: { detail in
                self.favoriteButton.isSelected = detail.favorite
                self.posterImage.setImage(with: detail.posterPath)
                self.backdropImage.setImage(with: detail.backdropPath)
                self.titleLabel.text = detail.title
                self.releaseDateLabel.text = detail.releaseDate
                self.runtimeLabel.text = detail.runtime
            })
            .disposed(by: disposeBag)

        viewModel?.detail
            .observeOn(MainScheduler.instance)
            .bind(to: infoVC.detail)
            .disposed(by: disposeBag)

        viewModel?.cast
            .observeOn(MainScheduler.instance)
            .bind(to: infoVC.cast)
            .disposed(by: disposeBag)

        viewModel?.crew
            .observeOn(MainScheduler.instance)
            .bind(to: infoVC.crew)
            .disposed(by: disposeBag)

        viewModel?.trailers
            .observeOn(MainScheduler.instance)
            .bind(to: infoVC.trailers)
            .disposed(by: disposeBag)
    }

    @objc private func didTapFavoriteButton() {
        viewModel?.updateFavorite()
    }

    private func selectViewController(withIndex index: Int) {
        pageViewController.setViewControllers(
            [viewControllerList[index]],
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
        let constant = indicatorWidth * CGFloat(menu)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.leadingIndicatorConstraint.constant = constant
                self.view.layoutIfNeeded()
            }) { _ in
                self.shouldSelectControllerByMenu = true
            }
        }
    }

    @IBAction func selectControllerByMenu(_ sender: UIButton) {
        if shouldSelectControllerByMenu {
            shouldSelectControllerByMenu = false
            shouldSelectControllerByScroll = selectedIndex == sender.tag ? true : false
            selectedIndex = sender.tag
            selectViewController(withIndex: sender.tag)
            selectMenuButtons(withTag: sender.tag) {
                self.updateIndicatorViewPosition(menu: sender.tag)
            }
        }
    }
}

extension MovieDetailViewController: LoadingViewDelegate {
    func didTapReloadButton() {
        loadingView.start {
            self.viewModel?.getMovieDetail()
        }
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldSelectControllerByScroll {
            let xOffset = scrollView.contentOffset.x
            let increment = CGFloat(selectedIndex) * indicatorWidth
            let constant = ((xOffset - screenWidth) / menuCount) + increment
            guard constant > 0, constant <= screenWidth - indicatorWidth else { return }
            leadingIndicatorConstraint.constant = constant
        }
    }
}

extension MovieDetailViewController: MovieDetailScrollDelegate {
    func didScroll(yOffset: CGFloat) {
        currentYOffset = yOffset

        let constant = normalViewTopConstraint - currentYOffset

        if yOffset > 0 {
            if constant <= topBarsHeight {
                showTopBarsView()
                headerViewTopConstraint.constant = -currentYOffset
                menuViewTopConstraint.constant = topBarsHeight
            } else if constant > topBarsHeight {
                hideTopBarsView()
                headerViewTopConstraint.constant = -currentYOffset
                menuViewTopConstraint.constant = constant
            }
        } else {
            hideTopBarsView()
            headerViewTopConstraint.constant = -currentYOffset
            menuViewTopConstraint.constant = constant
        }
    }

    private func showTopBarsView() {
        guard topBarsView.alpha == 0, shouldShowTopBarsView else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.title = self.viewModel?.movieTitle
                self.topBarsView.alpha = 1
            }
        }
    }

    private func hideTopBarsView() {
        guard topBarsView.alpha == 1 else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.title = nil
                self.topBarsView.alpha = 0
            }
        }
    }
}

extension MovieDetailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
