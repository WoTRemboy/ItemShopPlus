//
//  DefaultNetworkService.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.12.2023.
//

import Foundation

protocol NetworkingService {
    func getQuestBundles(completion: @escaping (Result<[QuestBundle], Error>) -> Void)
    func getShopItems(completion: @escaping (Result<[ShopItem], Error>) -> Void)
    func getBattlePassItems(completion: @escaping (Result<BattlePass, Error>) -> Void)
    func getCrewItems(completion: @escaping (Result<CrewPack, Error>) -> Void)
    func getAccountStats(nickname: String, platform: String?, completion: @escaping (Result<Stats, Error>) -> Void)
    func getMapItems(completion: @escaping (Result<[Map], Error>) -> Void)
}

final class DefaultNetworkService: NetworkingService {
    
    // MARK: - Properties
    
    private let session: URLSession
    private let baseURL = URL(string: "https://fortniteapi.io")
    private let token = "8b1729e0-29cc1b7d-71873902-21bf48f0"
    
    // MARK: - Initialization
    
    init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 15
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    // MARK: - Quests Module Request
    
    func getQuestBundles(completion: @escaping (Result<[QuestBundle], Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v3/challenges")
        
        let queryItems = [URLQueryItem(name: "season", value: "current"), URLQueryItem(name: "lang", value: "en")]
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
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
    
    func getShopItems(completion: @escaping (Result<[ShopItem], Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v2/shop")
        
        let queryItems = [URLQueryItem(name: "lang", value: "en")]
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
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
    
    func getBattlePassItems(completion: @escaping (Result<BattlePass, Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v2/battlepass")
        
        let queryItems = [URLQueryItem(name: "lang", value: "en"),
                          URLQueryItem(name: "season", value: "current")]
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
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
    
    func getCrewItems(completion: @escaping (Result<CrewPack, Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v2/crew")
        
        let queryItems = [URLQueryItem(name: "lang", value: "en")]
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
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
    
    // MARK: - Stats Module Request
    
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
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
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
    
    func getMapItems(completion: @escaping (Result<[Map], Error>) -> Void) {
        guard var url = baseURL else { return }
        url = url.appendingPathComponent("v1/maps/list")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
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
    
    // MARK: - Request Settings
    
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

enum NetworkingError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
    case emptyResponse
    case invalidData
}
