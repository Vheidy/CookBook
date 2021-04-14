//
//  LoadDishViewController.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 08.04.2021.
//

import UIKit
import SafariServices

class LoadDishViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    var customSearchBar: UISearchBar
    var searchService: RecipeProvider
    var collectionView: UICollectionView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        collectionView.reloadData()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        customSearchBar = UISearchBar()
        searchService = SearchService()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setLayout()
        setParameters()
        
    }
    
    /// When user tap somewhere editing ends
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    /// This method calls when an error ocurs and show alert with more information
    /// - Parameter title: Title for alert
    func showErrorAlert(with title: String) {
        let alertController = UIAlertController(title: title, message: "Please try again later", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionOK)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: UISearchBarDelegate implementation
    
    /// This method calls when searchButton taped
    /// - Parameter searchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        search(for: searchBar.text)
    }
    
    /// This method called when searchBar did end editing
    /// - Parameter searchBar
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        search(for: searchBar.text)
    }
    
    /// Check the word and search this in model
    /// - Parameter word: search keyword
    private func search(for word: String?)
    {
        guard let text = word else { return }
        searchService.search(for: text, successPath: collectionView.reloadData, failurePath: showErrorAlert(with:))
    }
    
    //MARK: UICollectionViewDataSource and Delegate implementation

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchService.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultViewCell", for: indexPath) as? SearchResultViewCell else { return UICollectionViewCell()}
        if let item = searchService.fetchItem(for: indexPath) {
            cell.configure(image: fetchImage(from: item.image), title: item.label)
        }
        return cell
    }
    
    /// Return image from url or standart image
    /// - Parameter urlString: url for image in string format
    private func fetchImage(from urlString: String) -> UIImage? {
        guard let standartImage = UIImage(named: "breakfast") else {
            return nil
        }
        do {
            guard let url = URL(string: urlString) else { return standartImage }
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print(error)
            return standartImage
        }
    }
    
    /// Show web-page when user tap on cells
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = searchService.fetchItem(for: indexPath), let url = URL(string: item.url) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }

    //MARK: Setup implemetation
    
    
    /// This method needs to end editing when user tap somewhere on the screen
    private func addGestureRecognizerForView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /// Set main parameters for searchBar and ColletionView, also set constraints
    private func setup() {
        view.addSubview(customSearchBar)
        view.addSubview(collectionView)
        customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentSize = CGSize(width: 150, height: 150)
        
        setConstraints(for: customSearchBar, collectionView: collectionView)
        addGestureRecognizerForView()
        
        navigationItem.title = "Search"
    }
    
    /// Set constraints for searchBar and collectionView
    private func setConstraints(for searchBar: UISearchBar, collectionView: UICollectionView) {
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
    }
    
    
    /// Set some parameters for collectionView and cusomSearchBar
    private func setParameters() {
        collectionView.dataSource = self
        collectionView.delegate = self
        customSearchBar.delegate = self
        customSearchBar.backgroundImage = UIImage()
        collectionView.backgroundColor = .clear
        collectionView.register(SearchResultViewCell.self, forCellWithReuseIdentifier: "SearchResultViewCell")
    }
    
    /// Set layout for collection view
    private func setLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 155, height: 155)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        layout.minimumLineSpacing = 20
        collectionView.setCollectionViewLayout(layout, animated: false)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
