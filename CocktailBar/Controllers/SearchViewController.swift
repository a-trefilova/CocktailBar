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

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [CurrentCocktail]()
    var collections = [CollectionModel]()
    var networkManager = CocktailNetworkManager()
    
    
    
    var database: Connection!
    
    let cocktailsTable = Table("cocktails")
    let drinkId = Expression<String>("drinkId")
    let drinkName = Expression<String>("drinkName")
    let category = Expression<String>("category")
    let alcohol = Expression<String>("alcohol")
    let glasses = Expression<String>("glasses")
    let instruction = Expression<String>("instruction")
    let imageUrl = Expression<String>("imageUrl")
    let ingridient1 = Expression<String?>("ingridient1")
    let ingridient2 = Expression<String?>("ingridient2")
    let ingridient3 = Expression<String?>("ingridient3")
    let ingridient4 = Expression<String?>("ingridient4")
    let ingridient5 = Expression<String?>("ingridient5")
    let ingridient6 = Expression<String?>("ingridient6")
    let ingridient7 = Expression<String?>("ingridient7")
    
    
    
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
        
        //set up database
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: true)
            let fileUrl = documentDirectory.appendingPathComponent("cocktails").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            
        }
        catch let error{
            print(error)
        }
        
        createTable()
        
        
    }
    
    private func createTable() {
        do {
            try database.run(cocktailsTable.drop(ifExists: true))
        } catch {
            print(error)
        }

        let createTable = self.cocktailsTable.create { (table) in
            table.column(self.drinkId, primaryKey: true)
            table.column(self.drinkName, unique: true)
            table.column(self.category)
            table.column(self.alcohol)
            table.column(self.glasses)
            table.column(self.instruction)
            table.column(self.imageUrl)
            table.column(self.ingridient1)
            table.column(self.ingridient2)
            table.column(self.ingridient3)
            table.column(self.ingridient4)
            table.column(self.ingridient5)
            table.column(self.ingridient6)
            table.column(self.ingridient7)
        }
        
        do {
            try self.database.run(createTable)
            //print("Table has been successfully created")
        } catch {
            print(error)
        }
    }
    
    func insertCocktail(fromJSON cocktail: CurrentCocktail) {
        let insertCocktail = self.cocktailsTable.insert(self.drinkId <- cocktail.drinkId,
                                                        self.drinkName <- cocktail.drinkName,
                                                        self.category <- cocktail.category,
                                                        self.alcohol <- cocktail.isAlco,
                                                        self.glasses <- cocktail.glasses,
                                                        self.instruction <- cocktail.instructions,
                                                        self.imageUrl <- cocktail.imageUrl,
                                                        self.ingridient1 <- cocktail.ingridient1,
                                                        self.ingridient2 <- cocktail.ingridient2,
                                                        self.ingridient3 <- cocktail.ingridient3,
                                                        self.ingridient4 <- cocktail.ingridient4,
                                                        self.ingridient5 <- cocktail.ingridient5,
                                                        self.ingridient6 <- cocktail.ingridient6,
                                                        self.ingridient7 <- cocktail.ingridient7)
        
        do {
            try self.database.run(insertCocktail)
           // print("Cocktails have been successfully inserted")
            
        } catch {
            print(error)
        }
    }
    
    func listCocktails() {
        do {
            let cocktails = try self.database.prepare(self.cocktailsTable)
            for cocktail in cocktails {
                let item = CurrentCocktail(drinkId: cocktail[self.drinkId],
                                           drinkName: cocktail[self.drinkName],
                                           category: cocktail[self.category],
                                           isAlco: cocktail[self.alcohol],
                                           glasses: cocktail[self.glasses],
                                           instructions: cocktail[self.instruction],
                                           imageUrl: cocktail[self.imageUrl],
                                           ingridient1: cocktail[self.ingridient1],
                                           ingridient2: cocktail[self.ingridient2],
                                           ingridient3: cocktail[self.ingridient3],
                                           ingridient4: cocktail[self.ingridient4],
                                           ingridient5: cocktail[self.ingridient5],
                                           ingridient6: cocktail[self.ingridient6],
                                           ingridient7: cocktail[self.ingridient7])
                    searchResults.append(item)
               // print("drinkId : \(cocktail[self.drinkId]), ddrinkName: \(cocktail[self.drinkName]), imageurl: \(cocktail[self.imageUrl])")
            }
        } catch {
            print(error)
        }
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "showDetails" {
//            guard let indexPath = tableView.indexPathForSelectedRow else { return }
//            let cocktailItem = searchResults[indexPath.row]
//            print("\n\n\n\n\n\n\n\(cocktailItem)\n\n\n\n\n\n\n\n\n")
//            let detailVC = segue.destination as! DetailViewController
//            detailVC.item = cocktailItem
//        }
//    }
    
    
    

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
        
        //performSegue(withIdentifier: "showDetails", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cocktail = searchResults[indexPath.row]
        let likeAction = UIContextualAction(style: .normal,
                                            title: "Like") { (_, _, _) in
                                               []}
        return UISwipeActionsConfiguration(actions: [likeAction])
    }
    

    
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        fetchSearchWord(searchController.searchBar.text!)
    }

    private func fetchSearchWord(_ searchText: String) {
       let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(searchText)"
        networkManager.fetchCurrentCocktail(url: urlString) { (cocktails) in
            
            //adding cocktails in database
            for item in cocktails{
                self.insertCocktail(fromJSON: item)
                
            }
            
            //initialize cocktail object with data FROM DATABASE, not from JSON
            self.listCocktails()
            
            //update array of search results
            self.searchResults = cocktails
            
            //update data for presentation
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }

}


    




