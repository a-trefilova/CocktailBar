//
//  Picture Manager.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 16.07.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import Foundation

class PictureManager {
    
    static func downloadImage(url: String, completion: @escaping (_ data: Data)->()) {
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        } .resume()
    }
}
