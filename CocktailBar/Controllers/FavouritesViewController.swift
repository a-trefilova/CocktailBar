//
//  FavouritesViewController.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 08.07.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    var arrayToReuse: [CurrentCocktail] = [CurrentCocktail]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var db: DBHelper = DBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: SearchViewCell.reuseId)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lovelyCocktails = db.readFavourites()
        tableView.reloadData()
    }
    
}

extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayToReuse.count == 0 {
            return lovelyCocktails.count
        } else {
           return arrayToReuse.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayToReuse.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.reuseId, for: indexPath) as! SearchViewCell
            cell.setData(with: lovelyCocktails[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.reuseId, for: indexPath) as! SearchViewCell
            cell.setData(with: arrayToReuse[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if arrayToReuse.count == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.item = lovelyCocktails[indexPath.row]
            self.present(detailVC, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.item = arrayToReuse[indexPath.row]
            self.present(detailVC, animated: true, completion: nil)
        }
    }
    
}
