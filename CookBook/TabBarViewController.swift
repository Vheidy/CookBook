//
//  TabBarViewController.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 31.03.2021.
//

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.isAccessibilityElement = true
        let ingredientScreenViewController = IngredientScreenTableViewController(nibName: nil, bundle: nil)
        let nc3 = UINavigationController(rootViewController: ingredientScreenViewController)
        let mainViewController = MainScreenTableViewController(with: [])
        let nc2 = UINavigationController(rootViewController: mainViewController)
        let loadViewController = LoadDishViewController()
        let nc1 = UINavigationController(rootViewController: loadViewController)
        
        ingredientScreenViewController.tabBarItem.image = UIImage(systemName: "rectangle.fill.on.rectangle.fill")
        mainViewController.tabBarItem.image = UIImage(systemName: "book")
        loadViewController.tabBarItem.image = UIImage(systemName: "square.and.pencil")

        ingredientScreenViewController.tabBarItem.title = "Ingredients"
        mainViewController.tabBarItem.title = "Dishes"
        loadViewController.tabBarItem.title = "Popular"
        
//        let vc1 = UINavigationController(rootViewController: mainViewController)
//        let vc2 = UINavigationController(rootViewController: ingredientScreenViewController)
//        let vc3 = UINavigationController(rootViewController: loadViewController)
//
        setViewControllers( [nc1 , nc2, nc3 ], animated: false)
        selectedViewController = nc2
    }

}
