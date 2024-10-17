//
//  WidgetNetworkService.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/14/24.
//

import Foundation

/// A protocol defining the network operations required to fetch shop items
protocol WidgetNetworkProtocol {
    /// Fetches shop items from the Fortnite API
    /// - Parameter completion: A closure that is called with the result, either a success with an array of `WidgetShopItem` or a failure with an error
    func getShopItems(completion: @escaping (Result<[WidgetShopItem], Error>) -> Void)
}

/// A service responsible for managing network requests related to the widget's shop items
final class WidgetNetworkService: WidgetNetworkProtocol {
    
    // MARK: - Properties
    
    /// The URL session used to perform network requests
    private let session: URLSession
    /// The base URL for the Fortnite API
    private let baseURL = URL(string: "https://fortniteapi.io")
    
    // MARK: - Initialization
    
    /// Initializes the network service with a default URL session configuration
    init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 15
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    // MARK: - Shop Module Request
    
    /// Fetches shop items from the API and parses them into an array of `WidgetShopItem`
    /// - Parameter completion: A closure that returns either a success with an array of `WidgetShopItem` or a failure with an error
    internal func getShopItems(completion: @escaping (Result<[WidgetShopItem], Error>) -> Void) {
        // Ensure the base URL is valid
        guard var url = baseURL else { return }
        
        // Append the shop endpoint to the base URL
        url = url.appendingPathComponent("v2/shop")
        
        // Set query parameters, e.g., language
        let queryItems = [URLQueryItem(name: "lang", value: Texts.NetworkRequest.language)]
        url.append(queryItems: queryItems)
        
        // Create the URL request and set the authorization token from the app's bundle
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        // Perform the request on a background thread
        DispatchQueue.global(qos: .utility).async {
            self.sendRequest(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        // Attempt to parse the JSON response
                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let bundleData = response?["shop"] as? [[String: Any]]
                        
                        // Convert the shop data into an array of `WidgetShopItem`
                        let items = bundleData?.compactMap { WidgetShopItem.sharingParse(sharingJSON: $0) } ?? []
                        completion(.success(items))
                    } catch {
                        // Handle any JSON parsing errors
                        completion(.failure(error))
                    }
                case .failure(let error):
                    // Handle request failure
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Request Settings
    
    /// Sends an HTTP request and returns the response data
    /// - Parameters:
    ///   - request: The URL request to send
    ///   - completion: A closure that returns either a success with the response data or a failure with an error
    private func sendRequest(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        
        // Start the data task to send the request
        let task = session.dataTask(with: request) { data, response, error in
            // Check for a networking error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Ensure the response is a valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkingError.invalidResponse))
                return
            }
            
            // Check if the status code is in the 200-299 range
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkingError.httpError(statusCode: httpResponse.statusCode)))
                return
            }
            
            // Ensure there is response data
            guard let responseData = data else {
                completion(.failure(NetworkingError.emptyResponse))
                return
            }
            
            // Pass the response data to the completion handler
            completion(.success(responseData))
        }
        task.resume()
    }
    
}

// MARK: - Networking Error Types

/// An enumeration of possible networking errors
enum NetworkingError: Error {
    // The response from the server was not valid
    case invalidResponse
    // The HTTP status code returned an error
    case httpError(statusCode: Int)
    // The response from the server was empty
    case emptyResponse
    // The data from the server was invalid
    case invalidData
}
