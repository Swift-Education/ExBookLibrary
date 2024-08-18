//
//  Requestable.swift
//  ExPokemon
//
//  Created by 강동영 on 8/18/24.
//

import Foundation

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParameters: [String: Any] { get }
    var bodyParameters: [String: Any] { get }
    var logger: NetworkLoggerInterface { get }
    
    func createRequest(with config: NetworkConfigurable) throws -> URLRequest
}

extension Requestable {
    func url(with config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(
            string: endpoint
        ) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()

        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    func createRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers
        headerParameters.forEach {
            allHeaders.updateValue($0.value, forKey: $0.key)
        }
        
        if !bodyParameters.isEmpty {
            let httpbody = try? JSONSerialization.data(withJSONObject: bodyParameters)
            urlRequest.httpBody = httpbody
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        
        return urlRequest
    }
}

// MARK: - HTTP Method Types
enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

// MARK: - Error
enum RequestGenerationError: Error {
    case components
}

private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
}
