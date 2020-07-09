//
//  Database.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 09.07.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit
import SQLite

//DB with all finded cocktails
var databaseArray = [CurrentCocktail]()


class Database {
    
    
    
    
    var database: Connection!
    
    let cocktailsTable = Table("cocktails")
    let drinkId = Expression<String>("drinkId")
    let drinkName = Expression<String>("drinkName")
    let category = Expression<String>("category")
    let alcohol = Expression<String>("alcohol")
    let glasses = Expression<String>("glasses")
    let instruction = Expression<String>("instruction")
    let imageUrl = Expression<String>("imageUrl")
    let ingridient1 = Expression<String?>("ingridient1")
    let ingridient2 = Expression<String?>("ingridient2")
    let ingridient3 = Expression<String?>("ingridient3")
    let ingridient4 = Expression<String?>("ingridient4")
    let ingridient5 = Expression<String?>("ingridient5")
    let ingridient6 = Expression<String?>("ingridient6")
    let ingridient7 = Expression<String?>("ingridient7")
    
    
    func setUpDB() {
        do {
                   let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                       in: .userDomainMask,
                                                                       appropriateFor: nil,
                                                                       create: true)
                   let fileUrl = documentDirectory.appendingPathComponent("cocktails").appendingPathExtension("sqlite3")
                   let database = try Connection(fileUrl.path)
                   self.database = database
                   
               }
               catch let error{
                   print(error)
               }
               
               createTable()
    }
    
    private func createTable() {
        do {
            try database.run(cocktailsTable.drop(ifExists: true))
        } catch {
            print(error)
        }

        let createTable = self.cocktailsTable.create { (table) in
            table.column(self.drinkId, primaryKey: true)
            table.column(self.drinkName, unique: true)
            table.column(self.category)
            table.column(self.alcohol)
            table.column(self.glasses)
            table.column(self.instruction)
            table.column(self.imageUrl)
            table.column(self.ingridient1)
            table.column(self.ingridient2)
            table.column(self.ingridient3)
            table.column(self.ingridient4)
            table.column(self.ingridient5)
            table.column(self.ingridient6)
            table.column(self.ingridient7)
        }
        
        do {
            try self.database.run(createTable)
            //print("Table has been successfully created")
        } catch {
            print(error)
        }
    }
    
    func insertCocktail(fromJSON cocktail: CurrentCocktail) {
        let insertCocktail = self.cocktailsTable.insert(self.drinkId <- cocktail.drinkId,
                                                        self.drinkName <- cocktail.drinkName,
                                                        self.category <- cocktail.category,
                                                        self.alcohol <- cocktail.isAlco,
                                                        self.glasses <- cocktail.glasses,
                                                        self.instruction <- cocktail.instructions,
                                                        self.imageUrl <- cocktail.imageUrl,
                                                        self.ingridient1 <- cocktail.ingridient1,
                                                        self.ingridient2 <- cocktail.ingridient2,
                                                        self.ingridient3 <- cocktail.ingridient3,
                                                        self.ingridient4 <- cocktail.ingridient4,
                                                        self.ingridient5 <- cocktail.ingridient5,
                                                        self.ingridient6 <- cocktail.ingridient6,
                                                        self.ingridient7 <- cocktail.ingridient7)
        
        do {
            try self.database.run(insertCocktail)
           // print("Cocktails have been successfully inserted")
            
        } catch {
            print(error)
        }
    }
    
    func listCocktails() {
        do {
            let cocktails = try self.database.prepare(self.cocktailsTable)
            for cocktail in cocktails {
                let item = CurrentCocktail(drinkId: cocktail[self.drinkId],
                                           drinkName: cocktail[self.drinkName],
                                           category: cocktail[self.category],
                                           isAlco: cocktail[self.alcohol],
                                           glasses: cocktail[self.glasses],
                                           instructions: cocktail[self.instruction],
                                           imageUrl: cocktail[self.imageUrl],
                                           ingridient1: cocktail[self.ingridient1],
                                           ingridient2: cocktail[self.ingridient2],
                                           ingridient3: cocktail[self.ingridient3],
                                           ingridient4: cocktail[self.ingridient4],
                                           ingridient5: cocktail[self.ingridient5],
                                           ingridient6: cocktail[self.ingridient6],
                                           ingridient7: cocktail[self.ingridient7])
                    searchResults.append(item)
              
            }
        } catch {
            print(error)
        }
    }

    
}
