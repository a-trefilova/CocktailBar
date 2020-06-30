//
//  DetailViewController.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 30.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var mainViewOutlet: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cocktailImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var item: CurrentCocktail!  {
        didSet {
            print("item data is here")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = item.drinkName
        PictureManager.downloadImage(url: item.imageUrl, completion: { [weak self] (data) in
            DispatchQueue.main.async {
                self?.cocktailImage.image = UIImage(data: data)
            }
        })
        categoryLabel.text = item.category
        instructionLabel.text = item.instructions
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
