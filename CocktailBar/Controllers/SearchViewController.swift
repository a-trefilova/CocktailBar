//
//  SearchViewController.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 24.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit
import SQLite




class SearchViewController: UIViewController, UISearchBarDelegate, UIPopoverPresentationControllerDelegate{
    
// MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
 // MARK: - Public Properties
    var collections = [CollectionModel]()
    var networkManager = CocktailNetworkManager()
    //var db: DBHelper = DBHelper()
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
        tableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: SearchViewCell.reuseId)
        setUpSearchController()
        setUpTableView()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //database = db.read()
        print(database.count)
    }
    
   
// MARK: - Private Methods
   private func setUpSearchController() {
    
        navigationController?.navigationBar.isTranslucent = true
        let navigationBar = navigationController?.navigationBar
        let navigationBarAppearence = UINavigationBarAppearance()
        navigationBarAppearence.shadowColor = .clear
        navigationBar?.scrollEdgeAppearance = navigationBarAppearence
        
        
        //navigationController?.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        //searchController.searchBar.barTintColor = .black
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    
        navigationController?.navigationBar.addSubview(searchController.searchBar)
    
        //setting up right button
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .bookmark, state: .normal)
    
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
           
        
        var arrayOfCategories: [String] = ["Reset all filters"]
        for item in database {
            if !arrayOfCategories.contains(item.category){
            arrayOfCategories.append(item.category)
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popVC = storyboard.instantiateViewController(withIdentifier: "popVC") as! FilterViewController
        popVC.arrayOfItems = arrayOfCategories
        popVC.modalPresentationStyle = .pageSheet
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = searchBar
        popOverVC?.sourceRect = CGRect(x: searchBar.bounds.width - 35 , y: searchBar.bounds.midY + 5 , width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popVC, animated: true)
        
        
       }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
   
    
    private func setUpTableView() {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
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
        if searchController.isActive {
            searchController.searchBar.showsBookmarkButton = false
        } else {
            searchController.searchBar.showsBookmarkButton = true
        }
        fetchSearchesFromDB(searchText: searchController.searchBar.text!)
        
    }

    private func fetchSearchesFromDB(searchText: String) {
        var searchText = searchText
        if searchText.contains(" ") {
            var arrayOfTwoWords = searchText.components(separatedBy: " ")
            let secondWords = arrayOfTwoWords[1].capitalizingFirstLetter()
            arrayOfTwoWords[1] = secondWords
            let returnedString = arrayOfTwoWords.joined(separator: " ")
            searchResults = database.filter({$0.drinkName.contains(returnedString)})
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            
            //getting cocktails, whose ingridients might contain search word
            let anotherResultsFirst = database.filter { (cocktail) -> Bool in
                let array = [cocktail.ingridient1, cocktail.ingridient2, cocktail.ingridient3, cocktail.ingridient4, cocktail.ingridient5, cocktail.ingridient6, cocktail.ingridient7]
                for item in array {
                    guard let item = item else { return false }
                    if item.contains(searchText) {
                        return true
                    }
                }
                return false
            }
            
            //COMMENTED SO FAR; getting cocktails, whose glasses might contain search word
//            let anotherResultsSecond = database.filter { (cocktail) -> Bool in
//                if cocktail.glasses == searchText {
//                    return true
//                }
//
//                return false
//            }
        
            searchResults = database.filter({$0.drinkName.contains(searchText)})
            
            //appending cocktails with relevant ingridients to the end of results, so these guys would be after relevant-by-name cocktails
            searchResults.append(contentsOf: anotherResultsFirst )
//          searchResults.append(contentsOf: anotherResultsSecond)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}


extension SearchViewController: UIScrollViewDelegate {

//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        searchController.isActive = false
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        searchController.isActive = true
//    }
//
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0) {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                //self.searchController.isActive = false
                
                self.navigationController?.setToolbarHidden(true, animated: true)
                print("Hide")
            }, completion: nil)

        }
        else {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.navigationBar.isHidden = false
                //self.searchController.isActive = true
                //self.navigationController?.setToolbarHidden(false, animated: true)
                print("Unhide")
            }, completion: nil)
          }
    }
    
    
}




extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func replaceWhiteSpaceWithUnderline() -> String {
        return self.replace(string: " ", replacement: "_")
    }
    
   func capitalizingFirstLetter() -> String {
       return prefix(1).capitalized + dropFirst()
   }

   mutating func capitalizeFirstLetter() {
       self = self.capitalizingFirstLetter()
   }
}
