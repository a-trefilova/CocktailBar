//
//  FilterViewController.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 21.08.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
//MARK: - INOutlets
    @IBOutlet weak var tableView: UITableView!
    
// MARK: - Public Properties
    var arrayOfItems: [String] = []
    var selectedItem : String!
    
    
//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
 
// MARK: - Public Methods
    func updateSelectedItem(completion: (String) -> Void) {
        guard let item = selectedItem else { return }
        completion(item)
    }

// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindSegue" {
            let mainVC = segue.destination as! SearchViewController
            mainVC.filterWord = selectedItem
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        true
    }

}

//MARK: - Table View Datasource & Delegate

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FilterViewCell
        cell.textLabel?.text = arrayOfItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedItem = arrayOfItems[indexPath.row]
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    
}
