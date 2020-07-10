//
//  FavoriteViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IFavoriteViewController: class {
    var router: IFavoriteRouter? { get set }
}

class FavoriteViewController: UIViewController {
    lazy var contentView: UIView = {
        let cv = UIView()
        return cv
    }()

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.keyboardDismissMode = .onDrag
        tv.allowsSelection = true
        tv.showsVerticalScrollIndicator = false
        tv.estimatedRowHeight = 100
        tv.sectionFooterHeight = 0
        return tv
    }()

    lazy var loadingView: LoadingView = {
        let lv = LoadingView()
        return lv
    }()

    var interactor: IFavoriteInteractor?
    var router: IFavoriteRouter?
    var mainVC: MainViewController?
    var movies = [MoviesModel.ViewModel]()

    var delegateCanScrollToTop = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainVC?.mainVCDelegate = self
        getFavoriteMovies()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegateCanScrollToTop = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegateCanScrollToTop = false
    }

    private func setupComponent() {
        title = "Favorites"
        mainVC = interactor?.parameters?["mainVC"] as? MainViewController

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellType(MovieTableViewCell.self)

        view.addSubview(contentView)
        contentView.addSubview(tableView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentView.topAnchor.constraint(equalTo: margins.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),

            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        loadingView.setup(in: contentView) {
            self.getFavoriteMovies()
        }
        
        loadingView.handleReload = { [weak self] in
            self?.discoverMovies()
        }
    }

    @objc private func discoverMovies() {
        mainVC?.selectedIndex = 1
    }

    private func getFavoriteMovies() {
        movies = FavoriteDB.share.list()

        if movies.count == 0 {
            loadingView.start {
                let message = "You have no Favorite Movies.."
                self.loadingView.stop(isSuccess: false, message: message)
                self.loadingView.reloadButton.setTitle("Discover Movies", for: .normal)
            }
        } else {
            loadingView.stop(isSuccess: true)
        }

        tableView.reloadData()
    }

    private func checkCurrentFavoriteMoviesCount() {
        if movies.count == 0 {
            loadingView.start {
                self.getFavoriteMovies()
            }
        }
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MovieTableViewCell.self, for: indexPath)
        cell.movies = movies[indexPath.row]
        cell.handleFavorite = { [weak self] favorite in
            guard let movie = self?.movies[indexPath.row] else { return }
            Helper.updateFavorite(movie: movie, favorite: favorite) {
                tableView.performBatchUpdates({
                    if favorite {
                        self?.movies.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        tableView.reloadData()
                    }
                })

                self?.checkCurrentFavoriteMoviesCount()
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = movies[indexPath.row].id
        guard id != 0 else {
            Toast.share.show(message: "Unknown Error")
            return
        }

        router?.navToMovieDetail(id: id)
    }
}

extension FavoriteViewController: MainVCDelegate {
    func scrollToTop() {
        if delegateCanScrollToTop, movies.count > 2 {
            tableView.scrollToRow(at: [0, 0], at: .none, animated: true)
        }
    }
}

extension FavoriteViewController: IFavoriteViewController {
    // do someting...
}
