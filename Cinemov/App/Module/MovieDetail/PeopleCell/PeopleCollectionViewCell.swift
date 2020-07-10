//
//  PeopleCollectionViewCell.swift
//  Cinemov
//
//  Created by Febri Adrian on 09/07/20.
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
            
            profileImage.setImage(with: people.profilePath, success: nil) {
                self.profileImage.image = UIImage(named: "defaultProfile")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }
}

