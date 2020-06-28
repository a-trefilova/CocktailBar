//
//  SearchViewCell.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 27.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {

    //@IBOutlet weak var cocktailLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cocktailImage: WebImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var isAlcoholLabel: UILabel!
    
    
    
    static let reuseId = "SearchCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        // Initialization code
    }
    
    override func prepareForReuse() {
        cocktailImage.set(imageURL: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
//    func setData(with properties: CurrentCocktail) {
//        cocktailImage.set(imageURL: properties.imageUrl)
//        drinkNameLabel.text = properties.drinkName
//        categoryLabel.text = properties.category
//        isAlcoholLabel.text = properties.isAlco
//        
//    }
}
