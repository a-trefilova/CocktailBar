//
//  SearchViewCell.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 27.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
// MARK: - IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet var cocktailImage: UIImageView! {
        willSet {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        
        didSet {
            
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true 
        }
    }
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var isAlcoholLabel: UILabel!
    @IBOutlet weak var gradientBackgroundView: GradientView!
    
// MARK: - Public Properties
    static let reuseId = "SearchCell"
    static let cellHeight: CGFloat = 200
    
    
// MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
    }
    
    override func prepareForReuse() {
        cocktailImage.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

 
// MARK: - Public Methods
    func setData(with properties: CurrentCocktail) {
        PictureManager.downloadImage(url: properties.imageUrl) { (data) in
            guard !data.isEmpty else { return }
            DispatchQueue.main.async {
                self.cocktailImage.image = UIImage(data: data)
            }
           return
        }
        drinkNameLabel.text = properties.drinkName
        categoryLabel.text = properties.category
        isAlcoholLabel.text = properties.isAlco
        
    }
    
// MARK: - Private Methods
    private func setUpCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        cocktailImage.layer.cornerRadius = cocktailImage.frame.width / 2
        cocktailImage.clipsToBounds = true
        
        cardView.layer.cornerRadius = 5
        cardView.clipsToBounds = true
        
        gradientBackgroundView.layer.cornerRadius = 5
        gradientBackgroundView.clipsToBounds = true 
    }
}
