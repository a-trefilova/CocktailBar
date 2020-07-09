//
//  File.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 06.07.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

var lovelyCocktails = [CurrentCocktail(drinkId: "15997",
                                       drinkName: "GG",
                                       category: "Ordinary Drink",
                                       isAlco: "Optional alcohol",
                                       glasses: "Collins Glass",
                                       instructions: "Pour the Galliano liqueur over ice. Fill the remainder of the glass with ginger ale and thats all there is to it. You now have a your very own GG.",
                                       imageUrl: "https://www.thecocktaildb.com/images/media/drink/vyxwut1468875960.jpg",
                                       ingridient1: Optional("Galliano"),
                                       ingridient2: Optional("Ginger ale"),
                                       ingridient3: Optional("Ice"),
                                       ingridient4: nil,
                                       ingridient5: nil,
                                       ingridient6: nil,
                                       ingridient7: nil)]

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

