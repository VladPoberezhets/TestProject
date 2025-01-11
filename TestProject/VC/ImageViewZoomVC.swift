//
//  ImageViewZoomVC.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 11.01.2025.
//

import Foundation
import UIKit

final class ImageViewZoomVC: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()

        view.delegate = self
        view.minimumZoomScale = 1.0
        view.maximumZoomScale = 4.0
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.bouncesZoom = false
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()

    private var image: UIImage?
    
    init(image: UIImage?) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let posterImage = image else { return }
        imageView.frame = calculateImageFrame(for: posterImage)
        scrollView.contentSize = imageView.bounds.size
    }
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.setupNavigationTitle(image: UIImage(named: "navigationImage"), title: String(localized: "HEADER_TITLE"))
        setupViews()
    }
    
    private func setupViews() {
        guard let _ = image else {
            self.setupUnavaliableView(title: String(localized: "UNAVALIBALE_VIEW_TITLE"), description: String(localized: "UNAVALIABLE_VIEW_DESCRIPTION"), image: UIImage(named: "warningImage"))
            return
        }
        setupScrollView()
        setupImageView()
    }
    
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    private func setupImageView() {
        guard let posterImage = self.image else { return }
        self.imageView.image = posterImage
        
        self.scrollView.addSubview(self.imageView)
    }
    
    private func calculateImageFrame(for image: UIImage) -> CGRect {
            let imageSize = image.size
            let screenSize = view.bounds.size
            let imageAspectRatio = imageSize.width / imageSize.height
            let screenAspectRatio = screenSize.width / screenSize.height

            if imageAspectRatio > screenAspectRatio {
                let width = screenSize.width
                let height = width / imageAspectRatio
                return CGRect(x: 0, y: (screenSize.height - height) / 2, width: width, height: height)
            } else {
                let height = screenSize.height
                let width = height * imageAspectRatio
                return CGRect(x: (screenSize.width - width) / 2, y: 0, width: width, height: height)
            }
        }
    
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            let point = gesture.location(in: imageView)
            let zoomRect = zoomRectForScale(scale: 2.0, center: point)
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        let size = CGSize(width: self.scrollView.bounds.width / scale,
                          height: self.scrollView.bounds.height / scale)
        let origin = CGPoint(x: center.x - size.width / 2,
                             y: center.y - size.height / 2)
        return CGRect(origin: origin, size: size)
    }
}

extension ImageViewZoomVC: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
                                    y: scrollView.contentSize.height * 0.5 + offsetY)
    }
}
