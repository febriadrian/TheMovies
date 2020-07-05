//
//  Toast.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation
import UIKit

class Toast {
    static let share = Toast()
    private var view: ToastView!
    
    init() {
        view = ToastView()
    }
    
    func show(message: String? = nil, completion: (() -> Void)? = nil) {
        guard let topMostView = UIApplication.shared.topMostViewController()?.view else { return }
        topMostView.endEditing(true)
        
        if let message = message {
            view.messageLabel.text = message
        } else {
            if NetworkStatus.isInternetAvailable {
                view.messageLabel.text = "Please try again later.."
            } else {
                view.messageLabel.text = "No Internet Connection"
            }
        }
        
        topMostView.addSubview(view)
        topMostView.bringSubviewToFront(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = topMostView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: topMostView.leftAnchor),
            view.rightAnchor.constraint(equalTo: topMostView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -12)
        ])
        
        animateView(animations: {
            self.view.subView?.alpha = 1
        }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.animateView(animations: {
                    self.view.subView?.alpha = 0
                }) {
                    self.view.removeFromSuperview()
                    completion?()
                }
            }
        }
    }
    
    private func animateView(animations: @escaping () -> Void, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: animations) { _ in
            completion()
        }
    }
}
