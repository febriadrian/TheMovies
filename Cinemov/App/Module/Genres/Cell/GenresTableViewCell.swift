//
//  GenresTableViewCell.swift
//  Cinemov
//
//  Created by Febri Adrian on 09/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class GenresTableViewCell: UITableViewCell {
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!

    var genres: GenresModel.Response.Genres? {
        didSet {
            guard let genres = genres else { return }
            nameLabel.text = genres.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            checkButton.isSelected = true
        } else {
            checkButton.isSelected = false
        }
    }
}
