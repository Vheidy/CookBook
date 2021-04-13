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
    case serverError
    case parsingError
}

protocol NetworkProtocol {
    func fetchRequestFor(query: String, completion: @escaping((Result<ResponseModel, APIError>) -> Void))
}

class NetworkService: NetworkProtocol {
    
//    static let shared = NetworkService()
    
    private var app_id = "0f316485"
    private var app_key = "a82e1ac9423ea6eee0c5137a0a58940a"
    private var basedURL = "https://api.edamam.com/search"
    
    func fetchRequestFor(query: String, completion: @escaping((Result<ResponseModel, APIError>) -> Void)) {
        request(query: query, completion: completion)
    }
    
    func request<T: Codable>(query: String, completion: @escaping((Result<T, APIError>) -> Void)) {
        guard !query.isEmpty else {
            completion(.failure(.internalError))
            return }
        guard let url = URL(string: "\(basedURL)?app_id=\(app_id)&app_key=\(app_key)&q=\(query)") else {
            completion(.failure(.internalError))
            return }
        let request = URLRequest(url: url)
        call(with: request, completion: completion)
    }
    
    private func call<T:Codable>(with request: URLRequest, completion: @escaping((Result<T, APIError>) -> Void)) {
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil, let resultData = data else {
                print(error.debugDescription)
                completion(.failure(.serverError))
                return
            }
            do {
                let object = try JSONDecoder().decode(T.self, from: resultData)
//                print(object)
                completion(.success(object))
            } catch {
                print(error)
                completion(.failure(.parsingError))
            }
        })
        task.resume()
    }
    
}
