//
//  MovieDetailInfoTableViewCell.swift
//  Cinemov
//
//  Created by Febri Adrian on 21/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol MovieDetailInfoDelegate {
    func updateCell()
}

class MovieDetailInfoTableViewCell: UITableViewCell {
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

    var delegate: MovieDetailInfoDelegate?
    var cast: PublishSubject<[MovieDetailModel.PersonModel]> = PublishSubject()
    var crew = PublishSubject<[MovieDetailModel.PersonModel]>()

    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupComponent()
        setupBinding()
    }

    func setupComponent() {
        selectionStyle = .none
        let italic = UIFont.systemFont(ofSize: 16, weight: .bold).italic()
        taglineLabel.font = italic

        castCollectionView.delegate = self
        crewCollectionView.delegate = self
        castCollectionView.registerCellType(PeopleCollectionViewCell.self)
        crewCollectionView.registerCellType(PeopleCollectionViewCell.self)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapContentLabel))
        overviewLabel.addGestureRecognizer(tap)
    }

    func setupBinding() {
        cast.bind(to: castCollectionView.rx.items(cellIdentifier: "PeopleCollectionViewCell", cellType: PeopleCollectionViewCell.self)) { _, cast, cell in
            cell.setupPersonView(person: cast)
        }.disposed(by: disposeBag)

        crew.bind(to: crewCollectionView.rx.items(cellIdentifier: "PeopleCollectionViewCell", cellType: PeopleCollectionViewCell.self)) { _, crew, cell in
            cell.setupPersonView(person: crew)
        }.disposed(by: disposeBag)
    }

    func setupInfoView(detail: MovieDetailModel.MVDetailModel) {
        genresLabel.text = detail.genres
        overviewLabel.text = detail.overview
        companiesLabel.text = detail.prodCompanies
        countriesLabel.text = detail.prodCountries
        homepageLabel.text = detail.homepage
        revenueLabel.text = detail.revenue
        budgetLabel.text = detail.budget
        originalTitleLabel.text = detail.originalTitle
        taglineLabel.text = detail.tagline
    }

    @objc private func didTapContentLabel() {
        if overviewLabel.numberOfLines == 0 {
            overviewLabel.numberOfLines = 4
        } else {
            overviewLabel.numberOfLines = 0
        }
        delegate?.updateCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension MovieDetailInfoTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 84, height: 118)
    }
}
