//
//  MovieTableViewCell.swift
//  Cinemov
//
//  Created by Febri Adrian on 09/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!

    var handleFavorite: ((_ favorite: Bool) -> Void)?

    var movies: MoviesModel.ViewModel? {
        didSet {
            guard let movie = movies else { return }
            titleLabel.text = movie.title
            releaseDateLabel.text = movie.releaseDate
            overviewLabel.text = movie.overview
            ratingLabel.text = movie.voteAverage
            favoriteButton.isSelected = movie.favorite

            posterImage.setImage(with: movie.posterUrl, success: {
                self.posterImage.contentMode = .scaleToFill
            }) {
                self.posterImage.contentMode = .center
                self.posterImage.image = UIImage(named: "tornfilm")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        subView.layer.cornerRadius = 10
        subView.layer.shadowOffset = .zero
        subView.layer.shadowOpacity = 0.2
        ratingView.layer.cornerRadius = ratingView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        guard let movie = movies else { return }
        handleFavorite?(movie.favorite)
    }
}
