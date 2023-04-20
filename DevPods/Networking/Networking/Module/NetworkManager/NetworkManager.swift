//
//  NetworkManager.swift
//  Networking
//
//  Created by Сергей Золотухин on 06.09.2022.
//

import Foundation
import Core

public protocol NetworkManagerProtocol {
    func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void)
    func request<T: Decodable>(urlString: String) async throws -> T
    func request2<T: Decodable>(urlString: String) async throws -> T
}

public final class NetworkManager {
    private let jsonService: JSONDecoderManagerProtocol
    public init(jsonService: JSONDecoderManagerProtocol) {
        self.jsonService = jsonService
    }
}

extension NetworkManager: NetworkManagerProtocol {

    public func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        let session = URLSession.shared
        let request = URLRequest(url: URL(string: urlString)!)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                let myError = NSError(domain: "my error domain", code: -123, userInfo: nil)
                completion(.failure(myError))
                return
            }
            self.jsonService.decode(data, completion: completion)
        }
        task.resume()
    }
    
    public func request2<T: Decodable>(urlString: String) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            guard let url = URL(string: urlString) else {
                return continuation.resume(throwing: NetworkError.url)
            }
            let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest) { [weak self] data, urlResponse, error in
                guard let self = self else {
                    return continuation.resume(throwing: NetworkError.unknown)
                }
                if let error = error {
                    return continuation.resume(throwing: error)
                }
                if let urlResponse = urlResponse as? HTTPURLResponse {
                    switch urlResponse.statusCode {
                    case 200...210:
                        guard let data = data else {
                            return continuation.resume(throwing: NetworkError.data)
                        }
                        return continuation.resume(with: self.jsonService.decode(data))
                    default:
                        return continuation.resume(throwing: NetworkError.statusCode)
                    }
                } else {
                    return continuation.resume(throwing: NetworkError.unknown)
                }
            }
        }
    }
    
    public func request<T: Decodable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.url
        }
        let urlRequest = URLRequest(url: url)
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        return try jsonService.decode(data)
    }
}

enum NetworkError: Error {
    case url
    case statusCode
    case data
    case unknown
}
