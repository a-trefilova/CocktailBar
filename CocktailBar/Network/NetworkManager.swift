//
//  NetworkManager.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 01.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class CocktailNetworkManager {
    
    static var cocktailsArray: [CurrentCocktail]!
    var onCompletion: ((CurrentCocktail) -> Void)!
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
                                                               imageUrl: cocktailsDictionary["strDrinkThumb"] as! String,
                                                               ingridient1: cocktailsDictionary["strIngredient1"] as? String,
                                                               ingridient2: cocktailsDictionary["strIngredient2"] as? String,
                                                               ingridient3: cocktailsDictionary["strIngredient3"] as? String,
                                                               ingridient4: cocktailsDictionary["strIngredient4"] as? String,
                                                               ingridient5: cocktailsDictionary["strIngredient5"] as? String,
                                                               ingridient6: cocktailsDictionary["strIngredient6"] as? String,
                                                               ingridient7: cocktailsDictionary["strIngredient7"] as? String
                                                               )
                                
                                cocktailArray.append(cocktails)
                                
                                
                                
                            }
                           completion(cocktailArray)
                        }
                    }
                } catch {
                    
                }
                
            }

        }.resume()

    }


    }

    
