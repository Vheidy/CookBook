//
//  NetworkService.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 08.04.2021.
//

import Foundation

struct Recipe: Codable {
    var label: String
    var image: String
    var url: String
}

struct HitsModel: Codable {
    var recipe: Recipe
}

struct ResponseModel: Codable {
    var hits: [HitsModel]
}

enum APIError: Error {
    case internalError
    case urlFormingError
    case serverError
    case parsingError
}

protocol NetworkProtocol {
    func fetchRequest(for urlString: String, completion: @escaping((Result<ResponseModel, APIError>) -> Void))
}

class NetworkService: NetworkProtocol {
    
    
    /// Create request for url and call it
    /// - Parameters:
    ///   - urlString: url in string format
    func fetchRequest(for urlString: String, completion: @escaping((Result<ResponseModel, APIError>) -> Void)) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlFormingError))
            return }
        let request = URLRequest(url: url)
        call(with: request, completion: completion)
    }
    
    /// Call the givaen request and return success or failure result
    private func call<T: Codable>(with request: URLRequest, completion: @escaping((Result<T, APIError>) -> Void)) {
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil, let resultData = data else {
                print(error.debugDescription)
                completion(.failure(.serverError))
                return
            }
            do {
                let object = try JSONDecoder().decode(T.self, from: resultData)
                completion(.success(object))
            } catch {
                print(error)
                completion(.failure(.parsingError))
            }
        })
        task.resume()
    }
}
