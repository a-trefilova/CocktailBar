//
//  FavouritesViewController.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 08.07.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    
// MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    
// MARK: - Public Properties
    var db: DBHelper = DBHelper()
    var arrayToReuse: [CurrentCocktail] = [CurrentCocktail]()
    var ingridient: String?
// MARK: - Private Properties
    private var numberOfSections: Int = 1
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: SearchViewCell.reuseId)
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changingTitle()
        lovelyCocktails = db.readFavourites()
        tableView.reloadData()
    }
 
// MARK: - Private methods
    
    private func changingTitle() {
        if arrayToReuse.count != 0 {
            self.navigationItem.title = "Cocktails with \(ingridient ?? "ingridient") "
            
        } else {
            self.navigationItem.title = "Favourites"
        }
    }
    
    private func setUpTableView() {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
}



// MARK: - Table View Data Source & Delegate 
extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayToReuse.count == 0 {
            return lovelyCocktails.count
        } else {
           return arrayToReuse.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.reuseId, for: indexPath) as! SearchViewCell
        if arrayToReuse.count == 0 {
            cell.setData(with: lovelyCocktails[indexPath.row])
        } else {
            cell.setData(with: arrayToReuse[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        if arrayToReuse.count == 0 {
            detailVC.item = lovelyCocktails[indexPath.row]
        } else {
            detailVC.item = arrayToReuse[indexPath.row]
        }
        self.present(detailVC, animated: true, completion: nil)
    }
    
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if arrayToReuse.count == 0 {
           return .delete
        }
        return .none
       }
       
       
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && arrayToReuse.count == 0{
            db.updateFavouritesByDrinkId(drinkId: lovelyCocktails[indexPath.row].drinkId, bool: false)
            lovelyCocktails.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
           }
       }
    
}
