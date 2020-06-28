//
//  ViewController.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 01.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var array: [CurrentCocktail]?
    let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita"
    var networkManager = CocktailNetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.fetchCurrentCocktail(url: urlString) { (cocktails) in
            self.array = cocktails
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print(self.array)
            }
        }
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }

    func prepareDataForPresenting() {
        
      
        
    }
    
    
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array?.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.nameLabel.text = array?[indexPath.row].drinkName
        return cell
    }
    
   
  
    
    
}
