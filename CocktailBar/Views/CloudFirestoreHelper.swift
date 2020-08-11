//
//  DBHelper.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 11.08.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import Foundation
import Firebase

class CloudFirestoreHelper {
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    let nm = CocktailNetworkManager()
    
    
    let arrayOfChars = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m" , "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    func getData() {
        var arrayOfCocktails = [CurrentCocktail]()
        
        for item in arrayOfChars {
            nm.fetchCurrentCocktail(url: "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=\(item)") { (cocktails) in
                arrayOfCocktails = cocktails
                for item in arrayOfCocktails {
                    self.ref = self.db.collection("TableOfDrinks").addDocument(data: [
                        "drinkId": item.drinkId,
                        "drinkName": item.drinkName,
                        "category": item.category,
                        "isAlco": item.isAlco,
                        "glasses": item.glasses,
                        "instructions": item.instructions,
                        "imageUrl": item.imageUrl,
                        "ingridient1": item.ingridient1 ?? "",
                        "ingridient2": item.ingridient2 ?? "",
                        "ingridient3": item.ingridient3 ?? "",
                        "ingridient4": item.ingridient4 ?? "",
                        "ingridient5": item.ingridient5 ?? "",
                        "ingridient6": item.ingridient6 ?? "",
                        "ingridient7": item.ingridient7 ?? ""
                        ], completion: { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added with ID: \(self.ref!.documentID)")
                            }
                    })
                }
                
            }
        }
        
    }
}
