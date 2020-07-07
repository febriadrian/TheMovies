//
//  NoMoviesTableViewCell.swift
//  TheMovies
//
//  Created by Febri Adrian on 05/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class NoMoviesTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
