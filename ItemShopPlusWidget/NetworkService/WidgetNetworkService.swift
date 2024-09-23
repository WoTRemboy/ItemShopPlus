//
//  WidgetNetworkService.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/14/24.
//

import Foundation

protocol WidgetNetworkProtocol {
    func getShopItems(completion: @escaping (Result<[WidgetShopItem], Error>) -> Void)
}

final class WidgetNetworkService: WidgetNetworkProtocol {
    
    // MARK: - Properties
    
    private let session: URLSession
    private let baseURL = URL(string: "https://fortniteapi.io")
    
    // MARK: - Initialization
    
    init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 15
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    // MARK: - Shop Module Request
    
    internal func getShopItems(completion: @escaping (Result<[WidgetShopItem], Error>) -> Void) {
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
                        let items = bundleData?.compactMap { WidgetShopItem.sharingParse(sharingJSON: $0) } ?? []
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
