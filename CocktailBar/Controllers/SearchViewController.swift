//
//  SearchViewController.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 24.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit
import SQLite
//import SQLite
import SQLite3
class SearchViewController: UIViewController, UISearchBarDelegate, UIPopoverPresentationControllerDelegate{
    
// MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
 // MARK: - Public Properties
    var collections = [CollectionModel]()
    var networkManager = CocktailNetworkManager()
    var searchResults = [CurrentCocktail]()
    var filterWord : String!
    
// MARK: - Private Properties
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        if searchController.isActive && searchResults.count != 0 {return true}
        return (searchController.isActive && !searchBarIsEmpty) || (searchResults.count != 0 && filterWord != nil ) 
    }
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: SearchViewCell.reuseId)
        setUpSearchController()
        setUpTableView()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(database.count)
    }
    
   
// MARK: - Private Methods
   private func setUpSearchController() {
    
        setUpNavBar()
        setUpSearchBar()
        
    
        //setting up right button - DELETED SO FAR
        //uncomment when the button will be needed
    
//        searchController.searchBar.delegate = self
//        searchController.searchBar.showsBookmarkButton = true
//        searchController.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .bookmark, state: .normal)
    
    }
    
    
    private func setUpNavBar() {
        navigationController?.navigationBar.isTranslucent = true
        let navigationBar = navigationController?.navigationBar
        let navigationBarAppearence = UINavigationBarAppearance()
        navigationBarAppearence.shadowColor = .clear
        navigationBar?.scrollEdgeAppearance = navigationBarAppearence
        navigationBar?.topItem?.title = nil
        navigationBar?.prefersLargeTitles = true
    }
    
    private func setUpSearchBar() {
        navigationItem.title = "Search"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationController?.navigationBar.addSubview(searchController.searchBar)
    }
    
    private func setUpTableView() {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private func fetchItems(ofIndex index: Int) {
        //let id = searchResults[index]
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: index, section: 0)
            if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
        }
        
    }
    
//MARK: - IBActions
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        if filterWord == "Reset all filters" {
            let results = database
            searchResults = results
            tableView.reloadData()
        } else  {
          let results = database.filter({$0.category == filterWord})
          searchResults = results
            tableView.reloadData()
        }
        
    }
    

//MARK: - UISearchBarDelegate
//uncomment when the right button will be needed
    
//    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
//
//
//        var arrayOfCategories: [String] = ["Reset all filters"]
//        for item in database {
//            if !arrayOfCategories.contains(item.category){
//            arrayOfCategories.append(item.category)
//            }
//        }
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let popVC = storyboard.instantiateViewController(withIdentifier: "popVC") as! FilterViewController
//        popVC.arrayOfItems = arrayOfCategories
//        popVC.modalPresentationStyle = .pageSheet
//        let popOverVC = popVC.popoverPresentationController
//        popOverVC?.delegate = self
//        popOverVC?.sourceView = searchBar
//        popOverVC?.sourceRect = CGRect(x: searchBar.bounds.width - 35 , y: searchBar.bounds.midY + 5 , width: 0, height: 0)
//        popVC.preferredContentSize = CGSize(width: 250, height: 250)
//        self.present(popVC, animated: true)
//
//
//       }
//
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }
    
    
    
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

extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            self.fetchItems(ofIndex: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}











