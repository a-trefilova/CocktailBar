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

    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [CurrentCocktail]()
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
                print("drinkId : \(cocktail[self.drinkId]), ddrinkName: \(cocktail[self.drinkName])")
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
        
       // cell.cocktailImage.set(imageURL: searchResults[indexPath.row].imageUrl)
        cell.drinkNameLabel.text = searchResults[indexPath.row].drinkName
        cell.categoryLabel.text = searchResults[indexPath.row].category
        cell.isAlcoholLabel.text = searchResults[indexPath.row].isAlco
       // cell.setData(with: searchResults[indexPath.row])
        return cell
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


class PresentedData {
    var arrayOfRecentCocktails = [Drink]()
    var arrayOfLovelyCocktails = [Drink]()
    var arrayOfMostPopularCocktails = [Drink]()
}
