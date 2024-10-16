//
//  VideoLoader.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.03.2024.
//

import Foundation
import AVKit

/// A class for loading and caching video data, supporting download and cache management of video files
final class VideoLoader {
    
    // MARK: - Properties
    
    /// The file manager used for handling cache directory operations
    private static let fileManager = FileManager.default
    /// The directory where video files are cached
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
    
    /// Loads a video from a URL string and caches it for future use
    /// - Parameters:
    ///   - urlString: The URL string of the video to be loaded
    ///   - completion: Completion handler that returns the URL of the video or `nil` if the loading fails
    /// - Returns: A `URLSessionDataTask` that can be used to manage the download
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
    
    /// Loads and plays a video in the provided `AVPlayerViewController`, showing an activity indicator during loading
    /// - Parameters:
    ///   - videoUrlString: The URL string of the video
    ///   - playerViewController: The `AVPlayerViewController` that will present the video
    ///   - activityIndicator: An activity indicator that is shown while the video is loading
    static func loadAndShowVideo(from videoUrlString: String, to playerViewController: AVPlayerViewController, activityIndicator: UIActivityIndicatorView) {
            DispatchQueue.main.async {
                playerViewController.view.alpha = 0.5
                if let url = URL(string: videoUrlString) {
                    activityIndicator.stopAnimating()
                    playerViewController.player = AVPlayer(url: url)
                    playerViewController.entersFullScreenWhenPlaybackBegins = true
                }
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                    playerViewController.view.alpha = 1.0
                }, completion: nil)
            }
    }
    
    /// Loads a video and presents it in full-screen using an `AVPlayerViewController`
    /// - Parameters:
    ///   - videoUrlString: The URL string of the video
    ///   - viewController: The view controller from which the video will be presented
    /// - Returns: A `URLSessionDataTask` for managing the video loading task
    static func loadAndShowItemVideo(from videoUrlString: String, viewController: UIViewController) -> URLSessionDataTask? {
        return loadVideo(urlString: videoUrlString) { video in
            DispatchQueue.main.async {
                let playerViewController = AVPlayerViewController()
                if let url = video {
                    playerViewController.player = AVPlayer(url: url)
                    playerViewController.entersFullScreenWhenPlaybackBegins = true
                    viewController.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
            }
        }
    }
    
    // MARK: - Cancel Method
    
    /// Cancels a video download task
    /// - Parameter task: The `URLSessionDataTask` that should be canceled
    static func cancelVideoLoad(task: URLSessionDataTask?) {
        task?.cancel()
    }
    
    // MARK: - Cache Methods
    
    /// Creates the cache directory if it doesn't already exist
    private static func createCacheDirectoryIfNeeded() throws {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    /// Caches the downloaded video data to the file system
    /// - Parameters:
    ///   - videoData: The `Data` object containing the video data
    ///   - key: The unique key (typically the video URL) for the cached file
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
    
    /// Retrieves the video file from the cache if available
    /// - Parameter key: The unique key (based on video URL) used to cache the file
    /// - Returns: The local file URL for the cached video, or `nil` if not found
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
    
    /// Cleans the video cache by either removing all cached files or removing only expired files
    /// - Parameters:
    ///   - entire: If `true`, clears the entire cache. If `false`, removes only expired videos based on access time
    ///   - completion: A completion handler that is called once the cache has been cleaned
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
    
    /// Calculates the total size of the video cache in megabytes
    /// - Returns: The size of the video cache in megabytes
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
    
    /// Updates the access time for a cached video file to mark it as recently used
    /// - Parameter cacheURL: The URL of the cached video file
    private static func markAccessTime(for cacheURL: URL) {
        do {
            try fileManager.setAttributes([.modificationDate: Date()], ofItemAtPath: cacheURL.path)
        } catch {
            print("Error marking access time for \(cacheURL): \(error)")
        }
    }
}
