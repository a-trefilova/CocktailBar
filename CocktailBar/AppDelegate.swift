//
//  AppDelegate.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 01.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import SQLite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var db: Firestore?
    let dbSQlite: DBHelper = DBHelper()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        db = Firestore.firestore()
        DispatchQueue.global(qos: .userInteractive).async {
            self.db!.collection("TableOfDrinks").getDocuments { (querySnapshot, err) in
            print(querySnapshot)
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                  let dict = document.data()
                    self.dbSQlite.insert(drinkId: dict["drinkId"] as! String,
                                    drinkName: dict["drinkName"] as! String,
                                    category: dict["category"] as! String,
                                    isAlco: dict["isAlco"] as! String,
                                    glasses: dict["glasses"] as! String,
                                    instructions: dict["instructions"] as! String,
                                    imageUrl: dict["imageUrl"] as! String,
                                    ingridient1: dict["ingridient1"] as! String,
                                    ingridient2: dict["ingridient2"] as! String,
                                    ingridient3: dict["ingridient3"] as! String,
                                    ingridient4: dict["ingridient4"] as! String,
                                    ingridient5: dict["ingridient5"] as! String,
                                    ingridient6: dict["ingridient6"] as! String,
                                    ingridient7: dict["ingridient7"] as! String,
                                    isFavourite: false)
                  
                }
            }
        }
            database = self.dbSQlite.read()
        print("DATABASE IS : \(database.count)")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    
    func applicationWillTerminate(_ application: UIApplication) {
        Analytics.logEvent("session_end", parameters: [
            "message" : "App has been terminated" as NSObject])
    }
}

