//
//  VideoLoader.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.03.2024.
//

import Foundation
import AVKit

class VideoLoader {
    
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    playerViewController.view.backgroundColor = .BackColors.backElevated
                }
            }
        }
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
//            markAccessTime(for: cacheURL)
        }
        return cacheURL
    }
}
