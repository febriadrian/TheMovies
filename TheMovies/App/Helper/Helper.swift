//
//  Helper.swift
//  TheMovies
//
//  Created by Febri Adrian on 05/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

struct Helper {
    static func arrayToString(_ array: [Any]?) -> String? {
        var string: String?
        if let array = array {
            for x in array {
                if string == nil {
                    string = "\(x)"
                } else {
                    string = string! + ", " + "\(x)"
                }
            }
        }
        return string ?? nil
    }

    static func dateFormatter(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let date = dateFormatter.string(from: date)
            return "Released on \(date)"
        }
        return "Released on n/a"
    }

    static func currencyFormatter(price: Int?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: price ?? 0)) ?? "n/a"
    }
}
