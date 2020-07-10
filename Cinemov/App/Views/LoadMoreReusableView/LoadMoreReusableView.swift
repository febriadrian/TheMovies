//
//  LoadMoreReusableView.swift
//  Cinemov
//
//  Created by Febri Adrian on 09/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class LoadMoreReusableView: UICollectionReusableView {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.alpha = 0
        activityIndicator.isHidden = true
    }
}
