//
//  MovieDetailInfoTableViewCell.swift
//  Cinemov
//
//  Created by Febri Adrian on 09/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

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

    var handleUpdateCell: (() -> Void)?

    var detail: MovieDetailModel.MVDetailModel? {
        didSet {
            guard let detail = detail else { return }
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
    }

    var cast: [MovieDetailModel.PeopleModel]? {
        didSet {
            if cast?.count == 0 {
                castView.isHidden = true
            } else {
                castCollectionView.reloadData()
            }
        }
    }

    var crew: [MovieDetailModel.PeopleModel]? {
        didSet {
            if crew?.count == 0 {
                crewView.isHidden = true
            } else {
                crewCollectionView.reloadData()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        let italic = UIFont.systemFont(ofSize: 16, weight: .bold).italic()
        taglineLabel.font = italic

        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        crewCollectionView.delegate = self
        crewCollectionView.dataSource = self
        castCollectionView.registerCellType(PeopleCollectionViewCell.self)
        crewCollectionView.registerCellType(PeopleCollectionViewCell.self)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapContentLabel))
        overviewLabel.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc private func didTapContentLabel() {
        if overviewLabel.numberOfLines == 0 {
            overviewLabel.numberOfLines = 4
        } else {
            overviewLabel.numberOfLines = 0
        }
        handleUpdateCell?()
    }
}

extension MovieDetailInfoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castCollectionView {
            return cast?.count ?? 0
        }
        return crew?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PeopleCollectionViewCell.self, for: indexPath)

        switch collectionView {
        case castCollectionView:
            cell.people = cast?[indexPath.item]
        case crewCollectionView:
            cell.people = crew?[indexPath.item]
        default:
            break
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 84, height: 118)
    }
}
