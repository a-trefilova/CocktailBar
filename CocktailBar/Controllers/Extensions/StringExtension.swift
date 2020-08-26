//
//  File.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 26.08.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import Foundation

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func replaceWhiteSpaceWithUnderline() -> String {
        return self.replace(string: " ", replacement: "_")
    }
    
   func capitalizingFirstLetter() -> String {
       return prefix(1).capitalized + dropFirst()
   }

   mutating func capitalizeFirstLetter() {
       self = self.capitalizingFirstLetter()
   }
}
