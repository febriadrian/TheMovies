//
//  DiscoverCollectionViewCell.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!

    var movies: HomeModel.Movies? {
        didSet {
            guard let movie = movies else { return }
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
    }
}
