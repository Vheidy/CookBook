//
//  LoadDishViewController.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 08.04.2021.
//

import UIKit
import SafariServices

class CustomTapGestureRecognezer: UITapGestureRecognizer {
    var url: URL?
}

class LoadDishViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    var searchBar: UISearchBar
    var searchService: RecipeProvider
    var collectionView: UICollectionView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        searchBar = UISearchBar()
        searchService = SearchService()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 155, height: 155)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        layout.minimumLineSpacing = 20
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.register(SearchResultViewCell.self, forCellWithReuseIdentifier: "SearchResultViewCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchService.numberOfItems
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultViewCell", for: indexPath) as? SearchResultViewCell else { return UICollectionViewCell()}
        if let item = searchService.fetchItem(for: indexPath) {
            cell.configure(image: item.image, title: item.label)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            let gesture = CustomTapGestureRecognezer(target: self, action: #selector(tapOnCell(with:)))
            gesture.url = item.url
            cell.addGestureRecognizer(gesture)
        }
        return cell
    }
    
    @objc func tapOnCell(with gestureRecognizer: CustomTapGestureRecognezer) {
        guard let url = gestureRecognizer.url else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Hi there")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        searchService.searchFor(word: text, errorHandler: showErrorAlert(with:), completion: collectionView.reloadData)
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        collectionView.reloadData()
    }

    private func setup() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 30),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
        
        collectionView.contentSize = CGSize(width: 150, height: 150)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        collectionView.backgroundColor = .clear
        
        
        navigationItem.title = "Search"
    }

    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    func showErrorAlert(with title: String) {
        let alertController = UIAlertController(title: title, message: "Please ty again later", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionOK)
        present(alertController, animated: true, completion: nil)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
