//
//  NetworkManager.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 01.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

struct CurrentDrinksData: Codable {
    
    let drinks: [Drink]
    
}

struct Drink: Codable {
    let idDrink : String
    let strDrink : String
    let strTags : String
    let strCategory : String
    let strAlcoholic : String
    let strGlass : String
    let strInstructions : String
    let strDrinkThumb : String  //this is image url
//    let strIngredient1 : String?
//    let strIngredient2 : String?
//    let strIngredient3 : String?
//    let strIngredient4 : String?
//    let strIngredient5 : String?
//    let strIngredient6 : String?
//    let strIngredient7 : String?
//    let strIngredient8 : String?
//    let strIngredient9 : String?
//    let strIngredient10 : String?
   
    

}

struct CurrentCocktail {
    let drinkId: String
    let drinkName: String
    let category: String
    let isAlco: String
    let glasses: String
    let instructions: String
    let imageUrl: String
    

}

class CocktailNetworkManager {
static var cocktailsArray: [CurrentCocktail]!

var onCompletion: ((CurrentCocktail) -> Void)!
//var cocktailsDictionary = NSDictionary()
var anyCocktail = [String: Any?]()
func fetchCurrentCocktail(url: String, completion: @escaping (_ cocktails: [CurrentCocktail])->())  {
    guard let url = URL(string: url) else { return }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data {
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    if let drinksContainer = json["drinks"] as? (NSArray) {
                        
                        var cocktailsDictionary = NSDictionary()
                        var cocktailArray = [CurrentCocktail]()
                        for drinks in drinksContainer {
                            
                            cocktailsDictionary = drinks as! NSDictionary
                            
                            let cocktails = CurrentCocktail(drinkId: cocktailsDictionary["idDrink"] as! String,
                                                           drinkName: cocktailsDictionary["strDrink"] as! String,
                                                           category: cocktailsDictionary["strCategory"] as! String,
                                                           isAlco: cocktailsDictionary["strAlcoholic"] as! String,
                                                           glasses: cocktailsDictionary["strGlass"] as! String,
                                                           instructions: cocktailsDictionary["strInstructions"] as! String,
                                                           imageUrl: cocktailsDictionary["strDrinkThumb"] as! String)
                            
                            cocktailArray.append(cocktails)
                            
                            
                            
                        }
                        print(cocktailArray)
                       completion(cocktailArray)
                    }
                }
            } catch {
                
            }
            
        }

    }.resume()

}


}

class PictureManager {
    static func downloadImage(url: String, completion: @escaping (_ data: Data)->()) {
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        } .resume()
    }
}
