//
//  ImageLoader.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 10.12.2023.
//

import UIKit
import Kingfisher

/// A class for loading and caching images from network requests using Kingfisher
final class ImageLoader {
    
    // MARK: - Properties
    
    /// The file manager used for managing the cache director
    private static let fileManager = FileManager.default
    /// The URL for the cache directory where images will be stored
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
    
    // MARK: - Loading Methods
    
    /// Loads an image from a URL string and resizes it based on the provided size
    /// The image is cached after it's retrieved
    /// - Parameters:
    ///   - urlString: The URL string of the image
    ///   - size: The target size to which the image will be resized
    ///   - completion: Completion handler that returns the image
    /// - Returns: A Kingfisher `DownloadTask` that can be used to manage the download
    static func loadImage(urlString: String?, size: CGSize, completion: @escaping (UIImage?) -> Void) -> DownloadTask? {
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
        
        let resource = Kingfisher.KF.ImageResource(downloadURL: url, cacheKey: urlString)
        let processor = ResizingImageProcessor(referenceSize: size, mode: .aspectFill)
        
        let task = KingfisherManager.shared.retrieveImage(with: resource, options: [.processor(processor), .memoryCacheExpiration(.expired), .diskCacheExpiration(.expired)]) { result in
            switch result {
            case .success(let value):
                DispatchQueue.global(qos: .utility).async {
                    setImageCache(image: value.image, key: urlString)
                }
                DispatchQueue.main.async {
                    completion(value.image)
                }
            case .failure:
                completion(nil)
            }
        }
        
        return task
    }
    
    /// Loads and sets the image to a `UIImageView` while applying a fade-in animation once the image is loaded
    /// - Parameters:
    ///   - imageUrlString: The URL string of the image
    ///   - imageView: The `UIImageView` where the image will be displayed
    ///   - size: The target size for the image
    /// - Returns: A Kingfisher `DownloadTask` for managing the download
    static func loadAndShowImage(from imageUrlString: String, to imageView: UIImageView, size: CGSize) -> DownloadTask? {
        return loadImage(urlString: imageUrlString, size: size) { image in
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
    
    // MARK: - Cancel Method
    
    /// Cancels an ongoing image download task
    /// - Parameter task: The Kingfisher `DownloadTask` to be canceled
    static func cancelImageLoad(task: DownloadTask?) {
        task?.cancel()
    }
    
    // MARK: - Cache Methods
    
    /// Creates the cache directory if it doesn't already exist
    private static func createCacheDirectoryIfNeeded() throws {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    /// Caches the image with the specified key
    /// - Parameters:
    ///   - image: The `UIImage` to be cached
    ///   - key: The unique key representing the image URL
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
    
    /// Retrieves an image from the cache if available
    /// - Parameter key: The unique key representing the image URL
    /// - Returns: The cached `UIImage` or `nil` if not found
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
    
    /// Cleans the cache by either removing all cached items or removing items based on expiration time
    /// - Parameters:
    ///   - entire: If `true`, clears the entire cache. If `false`, removes only expired items
    ///   - completion: Completion handler to be called once cache cleaning is done
    static func cleanCache(entire: Bool, completion: @escaping () -> Void) {
        do {
            let cacheExpirationInterval: TimeInterval = 24 * 60 * 60 // 24 hours
            
            let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for fileURL in contents {
                if entire {
                    try fileManager.removeItem(at: fileURL)
                } else {
                    let accessDate = try fileManager.attributesOfItem(atPath: fileURL.path)[.modificationDate] as? Date
                    
                    if let accessDate = accessDate, Date().timeIntervalSince(accessDate) > cacheExpirationInterval {
                        try fileManager.removeItem(at: fileURL)
                    }
                }
            }
            completion()
        } catch {
            print("Error cleaning cache: \(error)")
        }
    }
    
    /// Calculates the total cache size in megabytes
    /// - Returns: The cache size in megabytes
    static func cacheSize() -> Float {
        do {
            let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            var totalSize: Int = 0
            let bytesInMegabyte: Float = 1024 * 1024
            
            for fileURL in contents {
                let fileAttributes = try fileManager.attributesOfItem(atPath: fileURL.path)
                if let fileSize = fileAttributes[.size] as? Int {
                    totalSize += fileSize
                }
            }
            
            let sizeInMegabytes = Float(totalSize) / bytesInMegabyte
            return sizeInMegabytes
        } catch {
            print("Error calculating cache size: \(error)")
            return 0
        }
    }
    
    // MARK: - Recently Used Time Marks Methods
    
    /// Updates the access time of a cached image to mark it as recently used
    /// - Parameter cacheURL: The URL of the cached image
    private static func markAccessTime(for cacheURL: URL) {
        do {
            try fileManager.setAttributes([.modificationDate: Date()], ofItemAtPath: cacheURL.path)
        } catch {
            print("Error marking access time for \(cacheURL): \(error)")
        }
    }
}
