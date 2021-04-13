//
//  SearchService.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 09.04.2021.
//

import Foundation
import UIKit

struct CollectionViewItem {
    var label: String
    var image: UIImage
    var url: URL?
}

protocol RecipeProvider {
    var numberOfItems: Int { get }
    func searchFor(word: String, errorHandler: ((String) -> ())?, completion: VoidCallback?)
    func fetchItem(for indexPath: IndexPath) -> CollectionViewItem?
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
//        searchFor(word: "lunch", errorHandler: nil, completion: nil)
    }
    
    func fetchItem(for indexPath: IndexPath) -> CollectionViewItem? {
        guard recipeStore.indices.contains(indexPath.row)else {
            return nil
        }
        let recipe = recipeStore[indexPath.row]
        guard let standartImage = UIImage(named: "breakfast") else {
            return nil
        }
        let image = self.fetchImage(from: recipe.image) ?? standartImage
        return CollectionViewItem(label: recipe.label, image: image, url: URL(string: recipe.url))
    }
    
    private func fetchImage(from urlString: String) -> UIImage? {
        do {
            guard let url = URL(string: urlString) else { return nil }
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    func searchFor(word: String, errorHandler: ((String) -> ())?, completion: VoidCallback?) {
        newtworkService.fetchRequestFor(query: word) {
            switch $0 {
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
                    errorHandler?(errorDescription)
                }
            case .success(let response):
                if response.hits.count > 0 {
                    self.updateStore(with: response)
                    DispatchQueue.main.async {
                        completion?()
                    }
                } else {
                    DispatchQueue.main.async {
                        errorHandler?("No results found")
                    }
                }
            }
        }
    }

    
    private func updateStore(with response: ResponseModel) {
        recipeStore = response.hits.map( { $0.recipe })
    }
    
}
