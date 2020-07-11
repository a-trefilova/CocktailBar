//
//  DBHelper.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 11.07.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper {
    let dbPath: String = "cocktails.sqlite3"
    var db: OpaquePointer?
    
    init() {
        db = openDatabase()
        createTable()
    }
    
    func openDatabase() -> OpaquePointer? {
        let fileUrl = try! FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
            create: false).appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            print(fileUrl)
            return db
        }
        
    }
    
    func createTable() {
        let createTableString: String = "CREATE TABLE IF NOT EXISTS cocktails(drinkId INTEGER PRIMARY KEY, drinkName TEXT, category TEXT, isAlco TEXT, glasses TEXT, instructions TEXT, imageUrl TEXT, ingridient1 TEXT, ingridient2 TEXT, ingridient3 TEXT, ingridient4 TEXT, ingridient5 TEXT, ingridient6 TEXT, ingridient7 TEXT, isFavourite INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("cocktails table created")
            } else {
                print("cocktails table could not be created ")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(drinkId: String, drinkName: String, category: String, isAlco: String, glasses: String, instructions: String, imageUrl: String, ingridient1: String, ingridient2: String, ingridient3: String, ingridient4: String, ingridient5: String, ingridient6: String, ingridient7: String, isFavourite: Bool  ) {
        let cocktails = read()
        for cocktail in cocktails {
            if cocktail.drinkId == drinkId {
                return
            }
        }
        guard  let drinkId = Int(String(drinkId)) else { return }
        let insertStatementString = "INSERT INTO cocktails (drinkId, drinkName, category, isAlco, glasses, instructions, imageUrl,  ingridient1, ingridient2, ingridient3, ingridient4, ingridient5, ingridient6, ingridient7,  isFavourite ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(drinkId))
            sqlite3_bind_text(insertStatement, 2, (drinkName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (category as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (isAlco as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (glasses as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (instructions as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (imageUrl as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (ingridient1 as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, (ingridient2 as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 10, (ingridient3 as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 11, (ingridient4 as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 12, (ingridient5 as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 13, (ingridient6 as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 14, (ingridient7 as NSString).utf8String, -1, nil)
            var int = 0
            if isFavourite {
                int = 1
            } else {
                int = 0
            }
            sqlite3_bind_int(insertStatement, 15, Int32(int))
            
            
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [CurrentCocktail]{
        let queryStatementString: String = "SELECT * FROM cocktails;"
        var queryStatement: OpaquePointer? = nil
        var psns: [CurrentCocktail] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let drinkId = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let drinkName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let category = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let isAlco = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let glasses = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let instructions = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let imageUrl = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))

                let ingridient1 = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                let ingridient2 = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                let ingridient3 = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
                let ingridient4 = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
                let ingridient5 = String(describing: String(cString: sqlite3_column_text(queryStatement, 11)))
                let ingridient6 = String(describing: String(cString: sqlite3_column_text(queryStatement, 12)))
                let ingridient7 = String(describing: String(cString: sqlite3_column_text(queryStatement, 13)))
                let isFavourite = sqlite3_column_int(queryStatement, 14)
                psns.append(CurrentCocktail(drinkId: drinkId,
                                            drinkName: drinkName,
                                            category: category,
                                            isAlco: isAlco,
                                            glasses: glasses,
                                            instructions: instructions,
                                            imageUrl: imageUrl,
                                            ingridient1: ingridient1,
                                            ingridient2: ingridient2,
                                            ingridient3: ingridient3,
                                            ingridient4: ingridient4,
                                            ingridient5: ingridient5,
                                            ingridient6: ingridient6,
                                            ingridient7: ingridient7))
                print("Query result: \(drinkId), \(drinkName)")
            }
        }  else {
                print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    
    func deleteByDrinkId(drinkId: String) {
        let deleteStatementStirng: String = "DELETE FROM cocktails WHERE drinkId = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
        
            sqlite3_bind_int(deleteStatement, 1, Int32(drinkId)!)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
