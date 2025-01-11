//
//  MovieTrailerVC.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 11.01.2025.
//

import Foundation
import WebKit

final class MovieTrailerVC: BaseUIViewController {
    
    private var videoKey: String
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        view.backgroundColor = .clear
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    init(videoKey: String) {
        self.videoKey = videoKey
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        setupWebView()
        loadYouTubeVideo()
    }

    private func setupWebView() {
        self.view.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }

    private func loadYouTubeVideo() {
        let youtubeURL = "https://www.youtube.com/embed/\(videoKey)"
        guard let url = URL(string: youtubeURL) else {
            self.showUnavaliableView()
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension MovieTrailerVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView finished loading URL")
        self.hideLoader()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("WebView failed to load URL: \(error.localizedDescription)")
        self.showUnavaliableView()
        self.hideLoader()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("WebView started loading URL")
        self.showLoader()
    }
}
