//
//  NetworkManager.swift
//  ExPokemon
//
//  Created by 강동영 on 8/2/24.
//

import Foundation

final class NetworkManager {
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    private let session: URLSession
    private let config: NetworkConfigurable
    init(session: URLSession, config: NetworkConfigurable) {
        self.session = session
        self.config = config
    }
}

protocol NetworkService {
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        completion: @escaping CompletionHandler<T>
    ) where E.Response == T
}
extension NetworkManager: NetworkService {
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E, completion: @escaping CompletionHandler<T>) where T == E.Response {
        guard let request = try? endpoint.createRequest(with: config) else { return }
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard
                let data = data,
                let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode)
            else {
                completion(.failure(NSError(domain: "no data", code: -1)))
                return
            }
            
            do {
                let userInfo: T = try JSONDecoder().decode(
                    T.self,
                    from: data
                )
                endpoint.logger.responseLogger(response: response, data: data)
                completion(.success(userInfo))
            } catch {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}
