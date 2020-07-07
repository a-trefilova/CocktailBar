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
    
    var datasource = DataProvider()
    var arrayToPresent: [CollectionModel] = [CollectionModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDataSource()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.reuseId)
        
    }
    
    func prepareDataSource() {
       let model = datasource.getModel(with: "gin")
        let model1 = datasource.getModel(with: "rum")
        let model2 = datasource.getModel(with: "vodka")
        let model3 = datasource.getModel(with: "beer")
        let model4 = datasource.getModel(with: "vine")
        arrayToPresent.append(model)
        arrayToPresent.append(model1)
        arrayToPresent.append(model2)
        arrayToPresent.append(model3)
        arrayToPresent.append(model4)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
    
    
}





