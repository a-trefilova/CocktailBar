//
//  CollectionViewCell.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 29.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

// MARK: - IBOutlets
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
// MARK: - Public Properties
    
    static let reuseId = "CollectionCell"
 
// MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
        
    }
    
    
 // MARK: - Private Methods
    private func setUpCell() {
        gradientView.layer.cornerRadius = 10
        cellView.layer.cornerRadius = 10
        gradientView.clipsToBounds = true
        cellView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = 10
        backgroundImageView.clipsToBounds = true 
        collectionLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
