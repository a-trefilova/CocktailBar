//
//  File.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 26.08.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import Foundation
import UIKit

extension SearchViewController: UIScrollViewDelegate {

//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        searchController.isActive = false
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        searchController.isActive = true
//    }
//
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0) {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                //self.searchController.isActive = false
                
                self.navigationController?.setToolbarHidden(true, animated: true)
                print("Hide")
            }, completion: nil)

        }
        else {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.navigationBar.isHidden = false
                //self.searchController.isActive = true
                //self.navigationController?.setToolbarHidden(false, animated: true)
                print("Unhide")
            }, completion: nil)
          }
    }
    
    
}
