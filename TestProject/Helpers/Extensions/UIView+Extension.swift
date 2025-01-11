//
//  UIView+Extension.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 09.01.2025.
//

import UIKit

extension UIView {

    private var activityIndicator: UIActivityIndicatorView? {
        get {
            return self.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
        }
        set {
            if let indicator = newValue {
                indicator.backgroundColor = .white
                self.addSubview(indicator)
//                indicator.center = self.center
                indicator.frame.size = self.bounds.size
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
    
    func showLoader() {
        if activityIndicator == nil {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let loader = UIActivityIndicatorView(style: .large)
                loader.hidesWhenStopped = true
                self.activityIndicator = loader
                self.activityIndicator?.startAnimating()
            }
            
        }
    }
    
    func hideLoader() {
        if activityIndicator != nil {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.activityIndicator?.stopAnimating()
                self.activityIndicator = nil
            }
        }
    }
}
