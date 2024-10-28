//
//  DefaultNetworkService.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.12.2023.
//

import Foundation

/// Protocol defining the required methods for network services
protocol NetworkingService {
    /// Fetches quest bundles
    func getQuestBundles(completion: @escaping (Result<[QuestBundle], Error>) -> Void)
    /// Fetches shop items
    func getShopItems(completion: @escaping (Result<[ShopItem], Error>) -> Void)
    /// Fetches battle pass items
    func getBattlePassItems(completion: @escaping (Result<BattlePass, Error>) -> Void)
    /// Fetches crew pack items
    func getCrewItems(completion: @escaping (Result<CrewPack, Error>) -> Void)
    /// Fetches bundle items
    func getBundles(completion: @escaping (Result<[BundleItem], Error>) -> Void)
    /// Fetches loot details
    func getLootDetails(completion: @escaping (Result<[LootDetailsItem], Error>) -> Void)
    /// Fetches account statistics for a given player
    func getAccountStats(nickname: String, platform: String?, completion: @escaping (Result<Stats, Error>) -> Void)
    /// Fetches map items
    func getMapItems(completion: @escaping (Result<[Map], Error>) -> Void)
    /// Fetches video related to an item
    func getItemVideo(id: String, completion: @escaping (Result<ItemVideo, Error>) -> Void)
}

/// A class implementing `NetworkingService` to handle network requests to Fortnite's API
final class DefaultNetworkService: NetworkingService {
    
    // MARK: - Properties
    
    /// URLSession used for making requests
    private let session: URLSession
    /// Base URL for the API
    private let baseURL = URL(string: "https://fortniteapi.io")
    
    // MARK: - Initialization
    
    /// Initializes the `DefaultNetworkService` with a default `URLSession`
    init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 15
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    // MARK: - Quests Module Request
    
    /// Fetches quest bundles from the API
    /// - Parameter completion: Completion handler with the result containing an array of `QuestBundle` or an error
    func getQuestBundles(completion: @escaping (Result<[QuestBundle], Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v3/challenges")
        
        let queryItems = [URLQueryItem(name: "season", value: "current"), URLQueryItem(name: "lang", value: Texts.NetworkRequest.language)]
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.sendRequest(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let bundleData = response?["bundles"] as? [[String: Any]]
                        let items = bundleData?.compactMap { QuestBundle.sharingParse(sharingJSON: $0) } ?? []
                        completion(.success(items))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Shop Module Request
    
    /// Fetches shop items from the API
    /// - Parameter completion: Completion handler with the result containing an array of `ShopItem` or an error
    func getShopItems(completion: @escaping (Result<[ShopItem], Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v2/shop")
        
        let queryItems = [URLQueryItem(name: "lang", value: Texts.NetworkRequest.language)]
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.sendRequest(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let bundleData = response?["shop"] as? [[String: Any]]
                        let items = bundleData?.compactMap { ShopItem.sharingParse(sharingJSON: $0) } ?? []
                        completion(.success(items))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Battle Pass Module Request
    
    /// Fetches battle pass items from the API
    /// - Parameter completion: Completion handler with the result containing a `BattlePass` object or an error
    func getBattlePassItems(completion: @escaping (Result<BattlePass, Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v2/battlepass")
        
        let queryItems = [URLQueryItem(name: "lang", value: Texts.NetworkRequest.language),
                          URLQueryItem(name: "season", value: "current")]
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.sendRequest(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let item = BattlePass.sharingParse(sharingJSON: response as Any) ?? BattlePass.emptyPass
                        completion(.success(item))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Crew Module Request
    
    /// Fetches crew pack items from the API
    /// - Parameter completion: Completion handler with the result containing a `CrewPack` object or an error
    func getCrewItems(completion: @escaping (Result<CrewPack, Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v2/crew")
        
        let queryItems = [URLQueryItem(name: "lang", value: Texts.NetworkRequest.language)]
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.sendRequest(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let items = CrewPack.sharingParse(sharingJSON: response as Any) ?? CrewPack.emptyPack
                        completion(.success(items))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Bundles Module Request
    
    /// Fetches bundle items from the API
    /// - Parameter completion: Completion handler with the result containing an array of `BundleItem` or an error
    func getBundles(completion: @escaping (Result<[BundleItem], any Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v2/bundles")
        
        let queryItems = [URLQueryItem(name: "lang", value: Texts.NetworkRequest.language), URLQueryItem(name: "available", value: "true")]
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.sendRequest(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let bundleData = response?["bundles"] as? [[String: Any]]
                        let items = bundleData?.compactMap { BundleItem.sharingParse(sharingJSON: $0) } ?? []
                        completion(.success(items))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Loot Details Module Request
    
    /// Fetches loot details from the API
    /// - Parameter completion: Completion handler with the result containing an array of `LootDetailsItem` or an error
    func getLootDetails(completion: @escaping (Result<[LootDetailsItem], any Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v1/loot/list")
        
        let queryItems = [URLQueryItem(name: "lang", value: Texts.NetworkRequest.language)]
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.sendRequest(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let bundleData = response?["weapons"] as? [[String: Any]]
                        let items = bundleData?.compactMap { LootDetailsItem.sharingParse(sharingJSON: $0) } ?? []
                        completion(.success(items))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Stats Module Request
    
    /// Fetches account stats for a specific player
    /// - Parameters:
    ///   - nickname: The player's in-game nickname
    ///   - platform: Optional platform information (e.g., Epic, Xbox, Playstation)
    ///   - completion: Completion handler with the result containing a `Stats` object or an error
    func getAccountStats(nickname: String, platform: String?, completion: @escaping (Result<Stats, any Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v1/stats")
        
        var queryItems = [URLQueryItem(name: "username", value: nickname)]
        if let platform {
            queryItems.append(URLQueryItem(name: "platform", value: platform))
        }
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.sendRequest(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let items = Stats.sharingParse(sharingJSON: response as Any) ?? Stats.emptyStats
                        completion(.success(items))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Maps Module Request
    
    /// Fetches map items from the API
    /// - Parameter completion: Completion handler with the result containing an array of `Map` or an error
    func getMapItems(completion: @escaping (Result<[Map], Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v1/maps/list")
        
        let queryItems = [URLQueryItem(name: "lang", value: Texts.NetworkRequest.language)]
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.sendRequest(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let bundleData = response?["maps"] as? [[String: Any]]
                        let items = bundleData?.compactMap { Map.sharingParse(sharingJSON: $0) } ?? []
                        completion(.success(items))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Item Video Module Request
    
    /// Fetches item video from the API
    /// - Parameters:
    ///   - id: The item's ID for which the video is requested
    ///   - completion: Completion handler with the result containing an `ItemVideo` object or an error
    func getItemVideo(id: String, completion: @escaping (Result<ItemVideo, Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v2/items/get")
        
        let queryItems = [URLQueryItem(name: "id", value: id), URLQueryItem(name: "lang", value: Texts.NetworkRequest.language)]
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.sendRequest(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let bundleData = response?["item"] as? [String: Any]
                        let items = ItemVideo.sharingParse(sharingJSON: bundleData as Any) ?? ItemVideo.emptyVideo
                        completion(.success(items))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Request Settings
    
    /// Sends a network request and handles the response
    /// - Parameters:
    ///   - request: The `URLRequest` to be sent
    ///   - completion: Completion handler with the result containing `Data` or an error
    private func sendRequest(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkingError.invalidResponse))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkingError.httpError(statusCode: httpResponse.statusCode)))
                return
            }
            guard let responseData = data else {
                completion(.failure(NetworkingError.emptyResponse))
                return
            }
            completion(.success(responseData))
        }
        
        task.resume()
    }
    
}

// MARK: - Networking Error Types

/// An enum representing various types of networking errors
enum NetworkingError: Error {
    // Indicates an invalid response from the server
    case invalidResponse
    // Indicates an HTTP error with a specific status code
    case httpError(statusCode: Int)
    // Indicates an empty response from the server
    case emptyResponse
    // Indicates invalid data was received
    case invalidData
}
