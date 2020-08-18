//
//  File.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 06.07.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class DataProvider {
    var nm = CocktailNetworkManager()
    
    public  func getModel(with ingridient: String, completion: @escaping (CollectionModel) -> Void) {
        var model: CollectionModel!
        var modelArray: [CurrentCocktail] = []
        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(ingridient)"
        nm.fetchCurrentCocktail(url: urlString) {  cocktails in
            print(cocktails.count)
            modelArray = cocktails
            model = CollectionModel(name: ingridient, emoji: "", arrayOfCocktail: modelArray)
            completion(model)
        }
        
    }
    
    public func getModelFromDB(with ingridient: String, completion: @escaping (CollectionModel) -> Void) {
        var model: CollectionModel!
        var modelArray: [CurrentCocktail] = []
        let ingridient = ingridient.capitalizingFirstLetter()
        modelArray = database.filter({$0.drinkName.contains(ingridient)})
        let anotherResultsFirst = database.filter { (cocktail) -> Bool in
                       let array = [cocktail.ingridient1, cocktail.ingridient2, cocktail.ingridient3, cocktail.ingridient4, cocktail.ingridient5, cocktail.ingridient6, cocktail.ingridient7]
                       for item in array {
                           guard let item = item else { return false }
                           if item.contains(ingridient) {
                               return true
                           }
                       }
                       return false
        }
        modelArray.append(contentsOf: anotherResultsFirst)
        
        model = CollectionModel(name: ingridient, emoji: "", arrayOfCocktail: modelArray)
        completion(model)
    }
}

