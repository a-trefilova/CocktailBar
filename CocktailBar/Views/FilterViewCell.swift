//
//  TableViewCell.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 21.08.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class FilterViewCell: UITableViewCell {

     var titleOfCell = String() 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkIfCellIsntEmpty()
        
    }

    private func checkIfCellIsntEmpty() {
        guard let text = self.textLabel?.text else { return }
        titleOfCell = text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
