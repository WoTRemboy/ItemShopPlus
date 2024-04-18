//
//  VideoLoader.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.03.2024.
//

import Foundation
import AVKit

final class VideoLoader {
    
    // MARK: - Properties
    
    private static let fileManager = FileManager.default
    private static let cacheDirectory: URL = {
        do {
            let cachesDirectory = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return cachesDirectory.appendingPathComponent("VideoCache")
        }
        catch {
            print("Cache directory URL error: \(error)")
        }
        return URL(fileURLWithPath: "")
    }()
    
    // MARK: - Loading Methods
    
    static func loadVideo(urlString: String?, completion: @escaping (URL?) -> Void) -> URLSessionDataTask? {
        guard let urlString = urlString else {
            completion(nil)
            return nil
        }
        if let videoFromCache = getVideoFromCache(from: urlString) {
            completion(videoFromCache)
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
            guard let loadedVideo = data else {
                print("No data found")
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                DispatchQueue.global(qos: .utility).async {
                    setVideoCache(videoData: loadedVideo, key: urlString)
                }
                completion(url)
            }
        }
        
        task.resume()
        return task
    }
    
    static func loadAndShowVideo(from videoUrlString: String, to playerViewController: AVPlayerViewController, activityIndicator: UIActivityIndicatorView) -> URLSessionDataTask? {
        return loadVideo(urlString: videoUrlString) { video in
            DispatchQueue.main.async {
                playerViewController.view.alpha = 0.5
                if let url = video {
                    activityIndicator.stopAnimating()
                    playerViewController.player = AVPlayer(url: url)
                    playerViewController.entersFullScreenWhenPlaybackBegins = true
                }
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                    playerViewController.view.alpha = 1.0
                }, completion: nil)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                    playerViewController.view.backgroundColor = .BackColors.backElevated
//                }
            }
        }
    }
    
    // MARK: - Cancel Method
    
    static func cancelVideoLoad(task: URLSessionDataTask?) {
        task?.cancel()
    }
    
    // MARK: - Cache Methods
    
    private static func createCacheDirectoryIfNeeded() throws {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    private static func setVideoCache(videoData: Data, key: String) {
        do {
            try createCacheDirectoryIfNeeded()
            guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            let cacheURL = cacheDirectory.appendingPathComponent(encodedKey)
            try videoData.write(to: cacheURL)
        } catch {
            print("Error saving image to cache: \(error)")
        }
    }
    
    private static func getVideoFromCache(from key: String) -> URL? {
        guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }
        let cacheURL = cacheDirectory.appendingPathComponent(encodedKey)
        guard FileManager.default.contents(atPath: cacheURL.path) != nil else {
            return nil
        }
        DispatchQueue.global(qos: .utility).async {
            markAccessTime(for: cacheURL)
        }
        return cacheURL
    }
    
    static func cleanCache(entire: Bool, completion: @escaping () -> Void) {
        do {
            let cacheExpirationInterval: TimeInterval = 90 * 24 * 60 * 60 // 90 days
            
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
    
    private static func markAccessTime(for cacheURL: URL) {
        do {
            try fileManager.setAttributes([.modificationDate: Date()], ofItemAtPath: cacheURL.path)
        } catch {
            print("Error marking access time for \(cacheURL): \(error)")
        }
    }
}
