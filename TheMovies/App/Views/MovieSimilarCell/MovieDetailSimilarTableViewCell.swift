//
//  MovieDetailSimilarTableViewCell.swift
//  TheMovies
//
//  Created by Febri Adrian on 05/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailSimilarTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    var movie: HomeModel.Movies? {
        didSet {
            guard let movie = movie else { return }
            titleLabel.text = movie.title
            releaseDateLabel.text = movie.releaseDate
            summaryLabel.text = movie.overview
            ratingLabel.text = movie.voteAverage
            posterImage.setImage(with: movie.posterUrl, success: {
                self.ratingView.isHidden = false
            })
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.isHidden = true
        ratingView.layer.cornerRadius = ratingView.frame.height / 2
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
