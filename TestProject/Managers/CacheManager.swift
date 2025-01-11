//
//  CacheManager.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 09.01.2025.
//

import Foundation
import UIKit

final class CacheManager {
    
    enum Directory {
        case Images
        
        var url: URL? {
            guard let baseUrl = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
            
            let url: URL
            
            switch self {
                case .Images: url = baseUrl.appendingPathComponent("Images")
            }
            
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                return url
            } catch {
                print("File - \((#file as NSString).lastPathComponent). Line - \(#line). Failed FileManager.default.createDirectory(at: \(url), withIntermediateDirectories: true, attributes: nil)")
                return nil
            }
        }
    }
    
    static let shared = CacheManager()
    
    private init() {}
    
    func cacheImage(_ image: UIImage?, with name: String) {
        DispatchQueue.global(qos: .background).async {
            guard
                let url = Directory.Images.url,
                let imageData = image?.pngData()
                else { return }
            
            let filename = url.appendingPathComponent(name)
            
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                try imageData.write(to: filename)
            } catch {
               print( "File - \((#file as NSString).lastPathComponent). Line - \(#line)")
            }
        }
    }
    
    func loadImage(with name: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard
                let url = Directory.Images.url?.appendingPathComponent(name),
                let imageData = try? Data(contentsOf: url),
                let image = UIImage(data: imageData)
                else { return completion(nil) }
            
            DispatchQueue.main.async { completion(image) }
        }
    }
}
