//
//  PeopleCollectionViewCell.swift
//  TheMovies
//
//  Created by Febri Adrian on 05/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class PeopleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var asLabel: UILabel!

    var people: MovieDetailModel.PeopleModel? {
        didSet {
            guard let people = people else { return }
            nameLabel.text = people.name

            if !people.character.isEmpty {
                asLabel.text = people.character
            } else {
                asLabel.text = people.job
            }

            if people.profilePath.isEmpty {
                let urlString = "https://www.festivalclaca.cat/imgfv/b/500-5009697_no-profile-picture-icon-circle.png"
                profileImage.setImage(with: urlString)
            } else {
                let urlString = API.imgBaseUrl + "w185" + people.profilePath
                profileImage.setImage(with: urlString)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }
}
