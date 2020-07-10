//
//  MovieDetailViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IMovieDetailViewController: class {
    var router: IMovieDetailRouter? { get set }

    func displayGetMovieDetail(detail: MovieDetailModel.MVDetailModel, cast: [MovieDetailModel.PeopleModel], crew: [MovieDetailModel.PeopleModel], similar: [MoviesModel.ViewModel], reviews: [MovieDetailModel.ReviewModel])
    func displayGetMovieDetailFailed(message: String)
    func displayUpdateFavorite(selfIsFavorite: Bool, similar: [MoviesModel.ViewModel])
}

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var topBarsView: UIView!
    @IBOutlet weak var topBarsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var leadingIndicatorViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmenIndicator: UIView!
    @IBOutlet weak var segmenIndicatorWidthConstraint: NSLayoutConstraint!

    var interactor: IMovieDetailInteractor?
    var router: IMovieDetailRouter?
    var headerView: MovieDetailHeaderView!
    var loadingView: LoadingView!
    var detail: MovieDetailModel.MVDetailModel?
    var cast: [MovieDetailModel.PeopleModel]?
    var crew: [MovieDetailModel.PeopleModel]?
    var similar: [MoviesModel.ViewModel]?
    var reviews: [MovieDetailModel.ReviewModel]?
    var id: Int?
    var isInitialLoading = true

    var topBarsHeight: CGFloat = 0
    var normalViewTopConstraint: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        setupComponent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isInitialLoading {
            guard let detail = detail, let similar = similar, similar.count > 1 else { return }
            interactor?.updateFavorite(selfId: detail.id, similar: similar)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let header = tableView.tableHeaderView else { return }
        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: 0)).height
    }

    private func setupComponent() {
        id = interactor?.parameters?["id"] as? Int

        extendedLayoutIncludesOpaqueBars = true
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0

        headerView = MovieDetailHeaderView()
        headerView.favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        topBarsHeight = statusBarHeight + navBarHeight
        topBarsHeightConstraint.constant = topBarsHeight
        headerView.posterTopConstraint.constant += topBarsHeight
        headerView.widthConstraint.constant = UIScreen.main.bounds.width
        normalViewTopConstraint = headerView.contentHeight + topBarsHeight
        viewTopConstraint.constant = normalViewTopConstraint

        tableView.registerCellType(MovieTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self

        let contentView = headerView.contentView
        tableView.contentInset = UIEdgeInsets(top: -topBarsHeight, left: 0, bottom: 0, right: 0)
        tableView.tableHeaderView = contentView
        tableView.tableHeaderView?.backgroundColor = .red
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellType(MovieDetailInfoTableViewCell.self)
        tableView.registerCellType(MovieTableViewCell.self)
        tableView.registerCellType(ReviewTableViewCell.self)
        tableView.registerCellType(NoDetailTableViewCell.self)

        loadingView = LoadingView()
        loadingView.handleReload = { [weak self] in
            self?.didTapReloadButton()
        }

        loadingView.setup(in: self.contentView) {
            self.getMovieDetail()
        }
    }

    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = Colors.darkBlue
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = .clear
        } else {
            segmentedControl.tintColor = .clear
        }
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
        ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: Colors.lightBlue,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)
        ], for: .selected)

        segmenIndicator.backgroundColor = Colors.lightBlue
        segmenIndicatorWidthConstraint.constant = UIScreen.main.bounds.width / CGFloat(segmentedControl.numberOfSegments)
    }

    private func getMovieDetail() {
        guard let id = id else { return }
        interactor?.getMovieDetail(id: id)
    }

    @objc private func didTapReloadButton() {
        loadingView.start {
            self.getMovieDetail()
        }
    }

    @IBAction func handleSegmentChange(_ sender: UISegmentedControl) {
        tableView.reloadData()

        let width = segmenIndicatorWidthConstraint.constant
        let menu = segmentedControl.selectedSegmentIndex
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.leadingIndicatorViewConstraint.constant = (width * CGFloat(menu))
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }

        if segmentedControl.selectedSegmentIndex == 0 ||
            segmentedControl.selectedSegmentIndex == 1 && similar?.count == 0 ||
            segmentedControl.selectedSegmentIndex == 2 && reviews?.count == 0 {
            tableView.allowsSelection = false
        } else {
            tableView.allowsSelection = true
        }
    }

    @objc private func didTapFavoriteButton() {
        guard let detail = detail else { return }
        let movie = MoviesModel.ViewModel(
            id: detail.id,
            title: detail.title,
            posterUrl: detail.posterPath,
            voteAverage: detail.voteAverage,
            overview: detail.overview,
            releaseDate: detail.releaseDate,
            favorite: detail.favorite,
            createdAt: 0
        )

        Helper.updateFavorite(movie: movie, favorite: detail.favorite) {
            self.detail?.favorite = !detail.favorite
            self.headerView.favoriteButton.isSelected = !detail.favorite
        }
    }
}

extension MovieDetailViewController: IMovieDetailViewController {
    func displayGetMovieDetail(detail: MovieDetailModel.MVDetailModel, cast: [MovieDetailModel.PeopleModel], crew: [MovieDetailModel.PeopleModel], similar: [MoviesModel.ViewModel], reviews: [MovieDetailModel.ReviewModel]) {
        self.detail = detail
        self.cast = cast
        self.crew = crew
        self.similar = similar
        self.reviews = reviews

        headerView.favoriteButton.isSelected = detail.favorite
        headerView.posterImage.setImage(with: detail.posterPath)
        headerView.backdropImage.setImage(with: detail.backdropPath)
        headerView.titleLabel.text = detail.title
        headerView.releaseDateLabel.text = detail.releaseDate
        headerView.runtimeLabel.text = detail.runtime
        tableView.reloadData()

        isInitialLoading = false
        loadingView.stop(isSuccess: true)
    }

    func displayGetMovieDetailFailed(message: String) {
        isInitialLoading = false
        loadingView.stop(isSuccess: false, message: message)
    }

    func displayUpdateFavorite(selfIsFavorite: Bool, similar: [MoviesModel.ViewModel]) {
        self.similar = similar
        detail?.favorite = selfIsFavorite
        headerView.favoriteButton.isSelected = selfIsFavorite
        tableView.performBatchUpdates({
            self.tableView.reloadData()
        })
    }
}

extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return 1
        case 1:
            if let count = similar?.count, count > 0 {
                return count
            }
            return 1
        default:
            if let count = reviews?.count, count > 0 {
                return count
            }
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(MovieDetailInfoTableViewCell.self, for: indexPath)
            cell.detail = detail
            cell.cast = cast
            cell.crew = crew
            cell.handleUpdateCell = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            return cell
        case 1:
            if similar?.count == 0 {
                let cell = tableView.dequeueReusableCell(NoDetailTableViewCell.self, for: indexPath)
                cell.messageLabel.text = "No similar movies found.."
                return cell
            }

            let cell = tableView.dequeueReusableCell(MovieTableViewCell.self, for: indexPath)
            cell.movies = similar?[indexPath.row]
            cell.handleFavorite = { [weak self] favorite in
                guard let movie = self?.similar?[indexPath.row] else { return }
                Helper.updateFavorite(movie: movie, favorite: favorite) {
                    tableView.performBatchUpdates({
                        self?.similar?[indexPath.row].favorite = !favorite
                        cell.movies = self?.similar?[indexPath.row]
                    })
                }
            }
            return cell
        default:
            if reviews?.count == 0 {
                let cell = tableView.dequeueReusableCell(NoDetailTableViewCell.self, for: indexPath)
                cell.messageLabel.text = "No reviews found.."
                return cell
            }

            let cell = tableView.dequeueReusableCell(ReviewTableViewCell.self, for: indexPath)
            cell.review = reviews?[indexPath.row]
            cell.handleUpdateCell = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            guard let id = similar?[indexPath.row].id else { return }
            router?.navToMovieDetail(id: id)
        default:
            break
        }
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let constant = normalViewTopConstraint - yOffset

        if yOffset > 0 {
            if constant <= topBarsHeight {
                showTopBarsView()
                viewTopConstraint.constant = topBarsHeight
            } else if constant > topBarsHeight {
                hideTopBarsView()
                viewTopConstraint.constant = constant
            }
        } else if yOffset <= 0 {
            hideTopBarsView()
            viewTopConstraint.constant = constant
        }
    }

    private func showTopBarsView() {
        guard topBarsView.alpha == 0 else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.title = self.detail?.title
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
