//
//  File.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 29.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class CollectionCreation {
    
    // var arrayToPresent = [CurrentCocktail]()
    var model: CollectionModel!
    let networkManager = CocktailNetworkManager()
    func fillArray(withDataOnResponse searchWord: String) -> [CurrentCocktail] {
        var arrayToPresent = [CurrentCocktail]()
        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(searchWord)"
        networkManager.fetchCurrentCocktail(url: urlString) { [weak self] (cocktails) in
            arrayToPresent = cocktails
        }
        return arrayToPresent
    }
    
    func createModel(by ingridient: String) -> CollectionModel{
        let array = fillArray(withDataOnResponse: ingridient)
        let model = CollectionModel(name: "Cocktails with \(ingridient)",
                                    emoji: "",
                                    arrayOfCocktail: array)
        return model
    }
    
    
    
}

