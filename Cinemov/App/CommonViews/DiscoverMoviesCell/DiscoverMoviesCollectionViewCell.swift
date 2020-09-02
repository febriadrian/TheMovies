//
//  DiscoverMoviesCollectionViewCell.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class DiscoverMoviesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!

    func setupView(movie: DiscoverMoviesModel.ViewModel) {
        ratingLabel.text = movie.voteAverage

        posterImage.setImage(with: movie.posterUrl, success: {
            self.posterImage.contentMode = .scaleToFill
        }) {
            self.posterImage.contentMode = .center
            self.posterImage.image = UIImage(named: "tornfilm")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.layer.cornerRadius = ratingView.frame.height / 2
    }
}
