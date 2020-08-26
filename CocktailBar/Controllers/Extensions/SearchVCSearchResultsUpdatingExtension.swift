//
//  File.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 26.08.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import Foundation
import UIKit

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
