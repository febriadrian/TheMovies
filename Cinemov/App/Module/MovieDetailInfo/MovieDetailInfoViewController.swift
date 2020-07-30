//
//  MovieDetailInfoViewController.swift
//  Cinemov
//
//  Created by Febri Adrian on 22/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import RxCocoa
import RxSwift
import UIKit

class MovieDetailInfoViewController: UIViewController {
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var companiesLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var countriesLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var crewCollectionView: UICollectionView!
    @IBOutlet weak var castView: UIView!
    @IBOutlet weak var crewView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    var main: MovieDetailViewController?
    var scrollDelegate: MovieDetailScrollDelegate?
    var viewModel: IMovieDetailInfoViewModel?
    var router: IMovieDetailInfoRouter?
    var detail: PublishSubject<MovieDetailModel.MVDetailModel> = PublishSubject()
    var cast: PublishSubject<[MovieDetailModel.PersonModel]> = PublishSubject()
    var crew: PublishSubject<[MovieDetailModel.PersonModel]> = PublishSubject()
    private let disposeBag = DisposeBag()

    var lastYOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
        setupBinding()
    }

    private func setupComponent() {
        main = viewModel?.parameters?["main"] as? MovieDetailViewController

        scrollView.delegate = self
        castCollectionView.delegate = self
        crewCollectionView.delegate = self
        castCollectionView.registerCellType(PeopleCollectionViewCell.self)
        crewCollectionView.registerCellType(PeopleCollectionViewCell.self)

        taglineLabel.font = UIFont.systemFont(ofSize: 16).italic()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        main?.shouldSelectControllerByScroll = true
    }

    private func setupBinding() {
        detail
            .bind { detail in
                self.genresLabel.text = detail.genres
                self.overviewLabel.text = detail.overview
                self.companiesLabel.text = detail.prodCompanies
                self.countriesLabel.text = detail.prodCountries
                self.homepageLabel.text = detail.homepage
                self.revenueLabel.text = detail.revenue
                self.budgetLabel.text = detail.budget
                self.originalTitleLabel.text = detail.originalTitle
                self.taglineLabel.text = detail.tagline
            }
            .disposed(by: disposeBag)

        cast
            .bind(to: castCollectionView.rx.items(cellIdentifier: "PeopleCollectionViewCell", cellType: PeopleCollectionViewCell.self)) { _, person, cell in
                cell.setupPersonView(person: person)
            }
            .disposed(by: disposeBag)

        crew
            .bind(to: crewCollectionView.rx.items(cellIdentifier: "PeopleCollectionViewCell", cellType: PeopleCollectionViewCell.self)) { _, person, cell in
                cell.setupPersonView(person: person)
            }
            .disposed(by: disposeBag)
    }
}

extension MovieDetailInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 84, height: 118)
    }
}

extension MovieDetailInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let yOffset = scrollView.contentOffset.y

        if xOffset == 0 || xOffset != 0, yOffset != 0 {
            lastYOffset = yOffset
        }

        scrollDelegate?.didScroll(yOffset: lastYOffset)
    }
}
