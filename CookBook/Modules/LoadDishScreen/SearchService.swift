//
//  SearchService.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 09.04.2021.
//

import Foundation
import UIKit

protocol RecipeProvider {
    var numberOfItems: Int { get }
    func search(for word: String, successPath: VoidCallback?, failurePath: ((String) -> ())?)
    func fetchItem(for indexPath: IndexPath) -> Recipe?
}

struct PathCreater {
    private enum Constants {
        static let app_id = "0f316485"
        static let app_key = "a82e1ac9423ea6eee0c5137a0a58940a"
        static let basedURL = "https://api.edamam.com/search"
    }
    
    /// Create path with new keyword
    /// - Parameter query: search keyword
    /// - Returns: url in string format
    static func fetchPath(for query: String) -> String {
        return "\(Constants.basedURL)?app_id=\(Constants.app_id)&app_key=\(Constants.app_key)&q=\(query)"
    }
}

class SearchService: RecipeProvider {
    
    var recipeStore: [Recipe]
    var newtworkService: NetworkProtocol
    
    var numberOfItems: Int {
        recipeStore.count
    }
    
    init() {
        recipeStore = []
        newtworkService = NetworkService()
    }
    
    /// Return the collectionViewItem for indexPath
    /// - Parameter indexPath: indexPath of requires cells
    /// - Returns: Recipe model
    func fetchItem(for indexPath: IndexPath) -> Recipe? {
        guard recipeStore.indices.contains(indexPath.row)else {
            return nil
        }
        return recipeStore[indexPath.row]

    }
    
    /// Search for keyword and handle the result
    /// - Parameters:
    ///   - word: search keyword
    ///   - successPath: handler for success result
    ///   - failurePath: handler for failure result
    func search(for word: String, successPath: VoidCallback?, failurePath: ((String) -> ())?) {
        newtworkService.fetchRequest(for: PathCreater.fetchPath(for: word)) { [unowned self] result in
            switch result {
            case .failure(let error):
                let errorDescription: String
                switch error {
                case .internalError:
                    errorDescription = "Invalid input"
                case .serverError:
                    errorDescription = "Server error"
                case .parsingError:
                    errorDescription = "Parsing error"
                }
                DispatchQueue.main.async {
                    failurePath?(errorDescription)
                }
            case .success(let response):
                if response.hits.count > 0 {
                    self.updateStore(with: response)
                    DispatchQueue.main.async {
                        successPath?()
                    }
                } else {
                    DispatchQueue.main.async {
                        failurePath?("No results found")
                    }
                }
            }
        }
    }

    
    /// Update recipeStore for new response
    private func updateStore(with response: ResponseModel) {
        recipeStore = response.hits.map( { $0.recipe })
    }
    
}
