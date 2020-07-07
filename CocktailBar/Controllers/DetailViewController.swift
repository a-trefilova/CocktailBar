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
    
    @IBOutlet weak var ingridient1Label: UILabel!
    @IBOutlet weak var ingridient2Label: UILabel!
    @IBOutlet weak var ingridient3Label: UILabel!
    @IBOutlet weak var ingridient4Label: UILabel!
    @IBOutlet weak var ingridient5Label: UILabel!
    @IBOutlet weak var ingridient6Label: UILabel!
    
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    
    
    var item: CurrentCocktail!  {
        didSet {
            print("item data is here")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.layer.cornerRadius = 10
        nameLabel.clipsToBounds = true
        
        cocktailImage.layer.cornerRadius = 10
        cocktailImage.clipsToBounds = true
        
        categoryLabel.layer.cornerRadius = 10
        categoryLabel.clipsToBounds = true
        
        instructionLabel.layer.cornerRadius = 15
        instructionLabel.clipsToBounds = true
        
        //fill outlets with data
        nameLabel.text = item.drinkName
        PictureManager.downloadImage(url: item.imageUrl, completion: { [weak self] (data) in
            DispatchQueue.main.async {
                self?.cocktailImage.image = UIImage(data: data)
            }
        })
        categoryLabel.text = item.category
        instructionLabel.text = item.instructions
        ingridient1Label.text = item.ingridient1
        ingridient2Label.text = item.ingridient2
        ingridient3Label.text = item.ingridient3
        ingridient4Label.text = item.ingridient4
        ingridient5Label.text = item.ingridient5
        ingridient6Label.text = item.ingridient6
        
        
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        print("LikeButtonTapped")
        
        let hadCocktail = lovelyCocktails.contains { (cocktail) -> Bool in
            if item == cocktail {
                return true
            } else {
                return false
            }
        }
        
        if !hadCocktail {
            lovelyCocktails.append(item)
        }
        
       // likeButtonOutlet.imageView?.image = UIImage(systemName: "heart.fill")
        
    }
    
    
}


