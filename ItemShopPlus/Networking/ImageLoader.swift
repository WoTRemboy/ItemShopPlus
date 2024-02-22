//
//  ImageLoader.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 10.12.2023.
//

import UIKit

class ImageLoader {
    
    private static let fileManager = FileManager.default
    
    private static let cacheDirectory: URL = {
        do {
            let cachesDirectory = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return cachesDirectory.appendingPathComponent("ImageCache")
        }
        catch {
            print("Cache directory URL error: \(error)")
        }
        return URL(fileURLWithPath: "")
    }()
    
    static func loadImage(urlString: String?, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        guard let urlString = urlString else {
            completion(nil)
            return nil
        }
        
        if let imageFromCache = getImageFromCache(from: urlString) {
            completion(imageFromCache)
            return nil
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error ?? "URLSession unknown error")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data found")
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                guard let loadedImage = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                DispatchQueue.global(qos: .utility).async {
                    setImageCache(image: loadedImage, key: urlString)
                }
                completion(loadedImage)
            }
        }
        
        task.resume()
        return task
    }
    
    static func loadAndShowImage(from imageUrlString: String, to imageView: UIImageView) -> URLSessionDataTask? {
        return loadImage(urlString: imageUrlString) { image in
            DispatchQueue.main.async {
                imageView.alpha = 0.5
                if let image = image {
                    imageView.image = image
                }
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                    imageView.alpha = 1.0
                }, completion: nil)
            }
        }
    }
    
    static func cancelImageLoad(task: URLSessionDataTask?) {
        task?.cancel()
    }
    
    private static func createCacheDirectoryIfNeeded() throws {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    private static func setImageCache(image: UIImage, key: String) {
        do {
            try createCacheDirectoryIfNeeded()
            guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            let cacheURL = cacheDirectory.appendingPathComponent(encodedKey)
            
            if let data = image.pngData() {
                try data.write(to: cacheURL)
                
            }
        } catch {
            print("Error saving image to cache: \(error)")
        }
    }
    
    private static func getImageFromCache(from key: String) -> UIImage? {
        guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }
        let cacheURL = cacheDirectory.appendingPathComponent(encodedKey)
        
        guard let imageData = FileManager.default.contents(atPath: cacheURL.path) else {
            return nil
        }
        DispatchQueue.global(qos: .utility).async {
            markAccessTime(for: cacheURL)
        }
        return UIImage(data: imageData)
    }
    
    static func cleanCache() {
        do {
            let cacheExpirationInterval: TimeInterval = 24 * 60 * 60 // 24 hours
            
            let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for fileURL in contents {
                let accessDate = try fileManager.attributesOfItem(atPath: fileURL.path)[.modificationDate] as? Date
                
                if let accessDate = accessDate, Date().timeIntervalSince(accessDate) > cacheExpirationInterval {
                    try fileManager.removeItem(at: fileURL)
                }
            }
        } catch {
            print("Error cleaning cache: \(error)")
        }
    }
    
    private static func markAccessTime(for cacheURL: URL) {
        do {
            try fileManager.setAttributes([.modificationDate: Date()], ofItemAtPath: cacheURL.path)
        } catch {
            print("Error marking access time for \(cacheURL): \(error)")
        }
    }
}
