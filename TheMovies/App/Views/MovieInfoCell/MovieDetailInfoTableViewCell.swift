//
//  MovieDetailInfoTableViewCell.swift
//  TheMovies
//
//  Created by Febri Adrian on 05/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var companiesLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var countriesLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var crewCollectionView: UICollectionView!

    var detail: MovieDetailModel.MVDetailModel? {
        didSet {
            guard let detail = detail else { return }
            genresLabel.text = detail.genres
            summaryLabel.text = detail.overview
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
            castCollectionView.reloadData()
        }
    }

    var crew: [MovieDetailModel.PeopleModel]? {
        didSet {
            crewCollectionView.reloadData()
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
