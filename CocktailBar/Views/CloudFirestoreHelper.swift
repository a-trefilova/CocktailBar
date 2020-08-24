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
    let dbSQlite: DBHelper = DBHelper()
    
    let arrayOfChars = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m" , "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    //This is utility method not actually calling anywhere in app cycle
    //It parses API and loads data in CLOUD FIRESTORE database
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
    
    
    //This is important method calling in appDelegate
    //It parses API, gets the array of results, then parses FIRESTORE DB and gets another array of results, then compares and, in case of difference, appends elements in firestore database
    
    func updateData() {
        db.collection("TableOfDrinks").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                var arrayOfCocktails = [CurrentCocktail]()
                
                //parsing API and getting the array of results
                for item in self.arrayOfChars {
                    self.nm.fetchCurrentCocktail(url: "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=\(item)") { (cocktails) in
                        arrayOfCocktails = cocktails
                        
                    }
                }
              
                var arrayOfCocktailsInFirestore = [CurrentCocktail]()
                //parsing firestore db
                for document in snapshot!.documents {
                    let dict = document.data()
                    let cocktail = CurrentCocktail(drinkId: dict["drinkId"] as! String,
                                                   drinkName: dict["drinkName"] as! String,
                                                   category: dict["category"] as! String,
                                                   isAlco: dict["isAlco"] as! String,
                                                   glasses: dict["glasses"] as! String,
                                                   instructions: dict["instructions"] as! String,
                                                   imageUrl: dict["imageUrl"] as! String,
                                                   ingridient1: dict["ingridient1"] as? String,
                                                   ingridient2: dict["ingridient2"] as? String,
                                                   ingridient3: dict["ingridient3"] as? String,
                                                   ingridient4: dict["ingridient4"] as? String,
                                                   ingridient5: dict["ingridient5"] as? String,
                                                   ingridient6: dict["ingridient6"] as? String,
                                                   ingridient7: dict["ingridient7"] as? String)
                 
                    arrayOfCocktailsInFirestore.append(cocktail)
                }
                
                //getting the difference and appending elements in firestore
                for item in arrayOfCocktails {
                    if !arrayOfCocktailsInFirestore.contains(item) {
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
}
