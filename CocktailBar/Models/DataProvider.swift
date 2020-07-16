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
    
}

