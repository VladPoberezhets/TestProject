//
//  BaseUIViewController.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 11.01.2025.
//

import Foundation
import UIKit

protocol BaseUIViewControllerProtocol: AnyObject {
    func showLoader()
    func hideLoader()
    func showUnavaliableView()
}

class BaseUIViewController: UIViewController, BaseUIViewControllerProtocol {
    func showLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.view.showLoader()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.view.hideLoader()
        }
    }
    
    func showUnavaliableView() {
        DispatchQueue.main.async { [weak self] in
            self?.setupUnavaliableView(title: String(localized: "UNAVALIBALE_VIEW_TITLE"), description: String(localized: "UNAVALIABLE_VIEW_DESCRIPTION"), image: UIImage(named: "warningImage"))
        }
    }
    
}
