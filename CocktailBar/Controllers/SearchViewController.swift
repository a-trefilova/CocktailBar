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
    
    
    private var searchController = UISearchController(searchResultsController: nil) {
        didSet {
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: SearchViewCell.reuseId)
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.reuseId)
    
        
        
        
        
        collections.append(PresentedData.collection1)
        collections.append(PresentedData.collection2)
        collections.append(PresentedData.collection3)
        collections.append(PresentedData.collection4)
        collections.append(PresentedData.collection5)
        
        
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
//        do {
//            try database.run(cocktailsTable.drop(ifExists: true))
//        } catch {
//            print(error)
//        }
//
        let createTable = self.cocktailsTable.create { (table) in
            table.column(self.drinkId, primaryKey: true)
            table.column(self.drinkName, unique: true)
            table.column(self.category)
            table.column(self.alcohol)
            table.column(self.glasses)
            table.column(self.instruction)
            table.column(self.imageUrl)
        }
        
        do {
            try self.database.run(createTable)
            print("Table has been successfully created")
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
                                                        self.imageUrl <- cocktail.imageUrl)
        
        do {
            try self.database.run(insertCocktail)
            print("Cocktails have been successfully inserted")
            
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
                                           imageUrl: cocktail[self.instruction])
                searchResults.append(item)
                print("drinkId : \(cocktail[self.drinkId]), ddrinkName: \(cocktail[self.drinkName]), imageurl: \(cocktail[self.imageUrl])")
            }
        } catch {
            print(error)
        }
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
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cocktail = searchResults[indexPath.row]
        let likeAction = UIContextualAction(style: .normal,
                                            title: "Like") { (_, _, _) in
                                                PresentedData.arrayOfLovelyCocktails.append(cocktail)
        }
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

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseId , for: indexPath) as! CollectionViewCell
        cell.collectionLabel.text = collections[indexPath.row].name
        cell.emojiLabel.text = collections[indexPath.row].emoji
        
        return cell
    }
    
    
}


class PresentedData {

    static var arrayOfLovelyCocktails = [CurrentCocktail]()
    
    static let collection1 = CollectionCreation().createModel(by: "rum")
    static let collection2 = CollectionCreation().createModel(by: "gin")
    static let collection3 = CollectionCreation().createModel(by: "vodka")
    static let collection4 = CollectionCreation().createModel(by: "tequila")
    static let collection5 = CollectionCreation().createModel(by: "vine")
}
