//
//  MovieDetailViewController.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IMovieDetailViewController: class {
    var router: IMovieDetailRouter? { get set }

    func displayGetMovieDetail(detail: MovieDetailModel.MVDetailModel, cast: [MovieDetailModel.PeopleModel]?, crew: [MovieDetailModel.PeopleModel]?, similar: [HomeModel.Movies], recommend: [HomeModel.Movies])
    func displayGetMovieDetailFailed(message: String)
}

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!

    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        sc.insertSegment(withTitle: "Info", at: 0, animated: true)
        sc.insertSegment(withTitle: "Similar", at: 1, animated: true)
        sc.insertSegment(withTitle: "Recommend", at: 1, animated: true)
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmenChange), for: .valueChanged)
        sc.backgroundColor = Colors.darkBlue
        if #available(iOS 13.0, *) {
            sc.selectedSegmentTintColor = .clear
        } else {
            sc.tintColor = .clear
        }
        sc.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
        ], for: .normal)
        sc.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: Colors.lightBlue,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)
        ], for: .selected)
        return sc
    }()

    lazy var segmenIndicator: UIView = {
        let si = UIView(frame: CGRect(x: 0, y: 38, width: UIScreen.main.bounds.width / CGFloat(segmentedControl.numberOfSegments), height: 2))
        si.backgroundColor = Colors.lightBlue
        return si
    }()

    lazy var loadingView: LoadingView = {
        let lv = LoadingView()
        return lv
    }()

    var interactor: IMovieDetailInteractor?
    var router: IMovieDetailRouter?

    var id: Int?
    var detail: MovieDetailModel.MVDetailModel?
    var cast: [MovieDetailModel.PeopleModel]?
    var crew: [MovieDetailModel.PeopleModel]?
    var similar: [HomeModel.Movies]?
    var recommend: [HomeModel.Movies]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }

    private func setupComponent() {
        title = "Movie Detail"
        id = interactor?.parameters?["id"] as? Int

        tableView.registerCellType(MovieDetailInfoTableViewCell.self)
        tableView.registerCellType(MovieDetailSimilarTableViewCell.self)
        tableView.registerCellType(NoMoviesTableViewCell.self)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 40

        loadingView.handleReload = { [weak self] in
            self?.didTapReloadButton()
        }

        loadingView.setup(in: contentView) {
            self.getMovieDetail()
        }
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

    @objc private func handleSegmenChange() {
        tableView.reloadData()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.segmenIndicator.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            }
        }

        if tableView.numberOfRows(inSection: 0) > 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.tableView.scrollToRow(at: [0, 0], at: .none, animated: true)
            }
        }

        if segmentedControl.selectedSegmentIndex == 0 ||
            segmentedControl.selectedSegmentIndex == 1 && recommend?.count == 0 ||
            segmentedControl.selectedSegmentIndex == 2 && similar?.count == 0 {
            tableView.allowsSelection = false
        } else {
            tableView.allowsSelection = true
        }
    }
}

extension MovieDetailViewController: IMovieDetailViewController {
    func displayGetMovieDetail(detail: MovieDetailModel.MVDetailModel, cast: [MovieDetailModel.PeopleModel]?, crew: [MovieDetailModel.PeopleModel]?, similar: [HomeModel.Movies], recommend: [HomeModel.Movies]) {
        self.detail = detail
        self.cast = cast
        self.crew = crew
        self.similar = similar
        self.recommend = recommend

        let posterString = API.imgBaseUrl + "w154" + detail.posterPath
        posterImage.setImage(with: posterString)
        let backdropString = API.imgBaseUrl + "w300" + detail.backdropPath
        backdropImage.setImage(with: backdropString)

        titleLabel.text = detail.title
        releaseDateLabel.text = detail.releaseDate
        runtimeLabel.text = detail.runtime
        tableView.reloadData()

        loadingView.stop(isSuccess: true)
    }

    func displayGetMovieDetailFailed(message: String) {
        loadingView.stop(isSuccess: false, message: message)
    }
}

extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return 1
        case 1:
            if recommend?.count == 0 {
                return 1
            }
            return recommend?.count ?? 0
        default:
            if similar?.count == 0 {
                return 1
            }
            return similar?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(MovieDetailInfoTableViewCell.self, for: indexPath)
            cell.detail = detail
            cell.cast = cast
            cell.crew = crew
            return cell
        case 1:
            if recommend?.count == 0 {
                let cell = tableView.dequeueReusableCell(NoMoviesTableViewCell.self, for: indexPath)
                cell.messageLabel.text = "No recommended movies found.."
                return cell
            }

            let cell = tableView.dequeueReusableCell(MovieDetailSimilarTableViewCell.self, for: indexPath)
            cell.movie = recommend?[indexPath.row]
            return cell
        default:
            if similar?.count == 0 {
                let cell = tableView.dequeueReusableCell(NoMoviesTableViewCell.self, for: indexPath)
                cell.messageLabel.text = "No similar movies found.."
                return cell
            }

            let cell = tableView.dequeueReusableCell(MovieDetailSimilarTableViewCell.self, for: indexPath)
            cell.movie = similar?[indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            guard let id = recommend?[indexPath.row].id else { return }
            router?.navToMovieDetail(id: id)
        case 2:
            guard let id = similar?[indexPath.row].id else { return }
            router?.navToMovieDetail(id: id)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame.size.width = UIScreen.main.bounds.width
        view.backgroundColor = Colors.darkBlue
        view.addSubview(segmentedControl)
        view.addSubview(segmenIndicator)
        return view
    }
}
