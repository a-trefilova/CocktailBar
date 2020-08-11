//
//  SearchViewController.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 24.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit
import SQLite


class SearchViewController: UIViewController{
    
// MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
 // MARK: - Public Properties
    var collections = [CollectionModel]()
    var networkManager = CocktailNetworkManager()
    //var db: DBHelper = DBHelper()
    var searchResults = [CurrentCocktail]()
    
// MARK: - Private Properties
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: SearchViewCell.reuseId)
        setUpSearchController()
        
//        DispatchQueue.global(qos: .background).async {
//            let cfh = CloudFirestoreHelper()
//            cfh.getData()
//
//            DispatchQueue.main.async {
//                print("data is loaded to firebase")
//            }
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //database = db.read()
        print(database.count)
    }
    
// MARK: - Private Methods
   private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
}



// MARK: - Table View Data Source & Delegate 
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering { return searchResults.count}
        return database.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.reuseId, for: indexPath) as! SearchViewCell
        
        let data = isFiltering ? searchResults[indexPath.row] : database[indexPath.row]
        cell.setData(with: data)
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let item = isFiltering ? searchResults[indexPath.row] : database[indexPath.row]
        detailVC.item = item
        self.present(detailVC, animated: true, completion: nil)
    }
    
}


// MARK: - Search Results Updating
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        fetchSearchesFromDB(searchText: searchController.searchBar.text!)
    }

    private func fetchSearchesFromDB(searchText: String) {
        searchResults = database.filter({$0.drinkName.contains(searchText)})
       
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}


extension SearchViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.isActive = false
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        searchController.isActive = true
    }
    
    
}




extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func replaceWhiteSpaceWithUnderline() -> String {
        return self.replace(string: " ", replacement: "_")
    }
    
    func replaceDowncasedToUppersCase(string: String) -> String {
        return string.uppercased()
        
    }
}
