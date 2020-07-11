//
//  SearchViewController.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 24.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit
import SQLite

var searchResults = [CurrentCocktail]()
var database = [CurrentCocktail]()
class SearchViewController: UIViewController{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var collections = [CollectionModel]()
    var networkManager = CocktailNetworkManager()
    var db: DBHelper = DBHelper()
    
    private var searchController = UISearchController(searchResultsController: nil) {
        didSet {
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: SearchViewCell.reuseId)
       
        
        //setUp search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        database = db.read()
        print(database)
        
    }
    


}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.reuseId, for: indexPath) as! SearchViewCell
        cell.setData(with: searchResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.item = searchResults[indexPath.row]
        self.present(detailVC, animated: true, completion: nil)
        
    }
    
    

    
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        fetchSearchWord(searchController.searchBar.text!)
    }

    private func fetchSearchWord(_ searchText: String) {
       let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(searchText)"
        networkManager.fetchCurrentCocktail(url: urlString) { (cocktails) in
            searchResults = cocktails
            
            //adding cocktails in database
            for item in cocktails {
                
                self.db.insert(drinkId: item.drinkId,
                          drinkName: item.drinkName,
                          category: item.category,
                          isAlco: item.isAlco,
                          glasses: item.glasses,
                          instructions: item.instructions,
                          imageUrl: item.imageUrl,
                          ingridient1: self.prepareOptionalValues(string: item.ingridient1),
                          ingridient2: self.prepareOptionalValues(string: item.ingridient2),
                          ingridient3: self.prepareOptionalValues(string: item.ingridient3),
                          ingridient4: self.prepareOptionalValues(string: item.ingridient4),
                          ingridient5: self.prepareOptionalValues(string: item.ingridient5),
                          ingridient6: self.prepareOptionalValues(string: item.ingridient6),
                          ingridient7: self.prepareOptionalValues(string: item.ingridient7),
                          isFavourite: false)
                 
            }
            
            //initialize cocktail object with data FROM DATABASE, not from JSON
            
            //update array of search results
            
            database = self.db.read()
            
            //update data for presentation
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    private func prepareOptionalValues(string: String?) -> String {
        guard let string = string else { return ""}
        if string.count >= 1 {
            return string
        }
        return ""
    }

}


    




