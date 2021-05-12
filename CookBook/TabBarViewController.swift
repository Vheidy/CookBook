//
//  TabBarViewController.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 31.03.2021.
//

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController {

    private lazy var logger = CBLogger()
    static let extraFunctionality = false

    override func viewDidAppear(_ animated: Bool) {
        let del = NSLogInitializationNumber()
        if false {
            logger.delegate = del
        } else {
            logger.testBlock = del.printOfInitialization
        }
        logger.printAllInitialization()
    }

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
        
        var ncIngredient: UINavigationController?
        var ncLoad: UINavigationController?
        
        if TabBarViewController.extraFunctionality {
            let ingredientScreenViewController = IngredientScreenTableViewController(nibName: nil, bundle: nil)
            ncIngredient = UINavigationController(rootViewController: ingredientScreenViewController)
            
            let loadViewController = LoadDishViewController()
            ncLoad = UINavigationController(rootViewController: loadViewController)
            
            ingredientScreenViewController.tabBarItem.image = UIImage(systemName: "rectangle.fill.on.rectangle.fill")
            loadViewController.tabBarItem.image = UIImage(systemName: "square.and.pencil")
            
            ingredientScreenViewController.tabBarItem.title = "Ingredients"
            loadViewController.tabBarItem.title = "Popular"
        }
        let mainViewController = MainScreenTableViewController(with: [])
        let ncMain = UINavigationController(rootViewController: mainViewController)

        mainViewController.tabBarItem.image = UIImage(systemName: "book")
        mainViewController.tabBarItem.title = "Dishes"
        
        if TabBarViewController.extraFunctionality, let nc1 = ncLoad, let nc3 = ncIngredient {
            
            viewControllers = [nc1, ncMain, nc3]
            selectedViewController = ncMain
        } else {
            setViewControllers([ncMain], animated: true)
//            viewControllers?.append(ncMain)
        }
    }
}
