//
//  LoadingView.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    private let xibName = "LoadingView"
    let loadingMessage = "Please wait.."
    var handleReload: (() -> Void)?
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        contentView.fixInView(self)
        messageLabel.text = loadingMessage
    }
    
    @IBAction func startReload(_ sender: UIButton) {
        handleReload?()
    }
    
    func setup(in view: UIView, completion: (() -> Void)? = nil) {
        self.view = view
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        start {
            completion?()
        }
    }
    
    func start(completion: (() -> Void)? = nil) {
        messageLabel.text = loadingMessage
        activityIndicator.startAnimating()
        reloadButton.alpha = 0
        reloadButton.isHidden = true
        view.bringSubviewToFront(contentView)
        animateViews(animations: {
            self.contentView.alpha = 1
            self.activityIndicator.alpha = 1
            self.messageLabel.alpha = 1
            self.activityIndicator.isHidden = false
            self.messageLabel.isHidden = false
        }) {
            completion?()
        }
    }
    
    func stop(isSuccess: Bool, message: String? = nil, completion: (() -> Void)? = nil) {
        if let message = message {
            messageLabel.text = message
        }
        
        if isSuccess {
            animateViews(animations: {
                self.contentView.alpha = 0
                self.view.sendSubviewToBack(self.contentView)
            }) {
                completion?()
            }
        } else {
            reloadButton.isHidden = false
            reloadButton.alpha = 1
            animateViews(animations: {
                self.activityIndicator.isHidden = true
                self.messageLabel.isHidden = false
                self.activityIndicator.alpha = 0
                self.messageLabel.alpha = 1
            }) {
                completion?()
            }
        }
        
        activityIndicator.stopAnimating()
    }
    
    private func animateViews(animations: @escaping () -> Void, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                animations()
            }) { _ in
                completion?()
            }
        }
    }
}
