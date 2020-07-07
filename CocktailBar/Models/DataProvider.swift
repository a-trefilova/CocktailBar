//
//  File.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 06.07.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

var lovelyCocktails = [CurrentCocktail]()

struct DataProvider {
    
    //var arrayOfCollections: [CollectionModel]?
    
    private func getData(with ingridient: String) -> [CurrentCocktail] {
        let nm = CocktailNetworkManager()
        var arrayToReturn = [CollectionModel]()
        var cocktailsArray = [CurrentCocktail]()
        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(ingridient)"
            nm.fetchCurrentCocktail(url: urlString) { (cocktails) in
               cocktailsArray = cocktails
           }
        return cocktailsArray
        
    }
    
     func getModel(with ingridient: String) -> CollectionModel {
        let arrayOfCocktails = getData(with: ingridient)
        let model = CollectionModel(name: ingridient, emoji: "", arrayOfCocktail: arrayOfCocktails)
        return model
    }
    
    
    
}

