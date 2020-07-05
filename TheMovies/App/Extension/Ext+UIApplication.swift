//
//  Ext+UIApplication.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
