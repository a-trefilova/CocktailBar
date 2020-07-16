//
//  2CollectionViewController.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 04.07.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class _CollectionViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var ingridients = ["gin", "rum", "vine", "beer"]
    lazy var datasource = DataProvider()
    var arrayToPresent: [CollectionModel] = [CollectionModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.reuseId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCollectionVC()
        
    }
  
    
    func prepareCollectionVC() {
        for item in ingridients {
             DataProvider().getModel(with: item) { model in
                self.arrayToPresent.append(model)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
  
    
    private func calculateSizeOfCell() -> CGSize {
        let screenSize = UIScreen.main.bounds
        let width = screenSize.width
        let height = screenSize.height
        let widthOfCell = width - 100
        let heightOfCell = height - 300
        
        return CGSize(width: widthOfCell, height: heightOfCell)
        
    }
   
    
    
}

extension _CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayToPresent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell" , for: indexPath) as? CollectionViewCell else {
            print("Cell hasn been created")
            return UICollectionViewCell()}
        let item = arrayToPresent[indexPath.item]
        let text = item.name
        print(item)
        
        cell.collectionLabel?.text = "Cocktails with \(text)" 
        
        
        
        return cell

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateSizeOfCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tableVC = storyboard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
        tableVC.arrayToReuse = arrayToPresent[indexPath.item].arrayOfCocktail
        self.present(tableVC, animated: true)
    }
    
}





