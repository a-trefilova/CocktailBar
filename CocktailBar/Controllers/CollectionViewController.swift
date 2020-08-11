//
//  2CollectionViewController.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 04.07.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {

// MARK: - IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
// MARK: - Public Properties
    var arrayToPresent: [CollectionModel] = [CollectionModel]()
    var ingridients = ["gin"]
    var allIngridientsForRandomize = ["gin",
                                      "rum",
                                      "vine",
                                      "beer",
                                      "tequila",
                                      "vodka",
                                      "aperol",
                                      "sambuca",
                                      "lemon",
                                      "grenadine",
                                      "soda"]
    lazy var datasource = DataProvider()
    
    
// MARK: - Private Properties
    private var numberOfSections: Int = 1
    private var lineSpacing: CGFloat = 100
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.reuseId)
        setUpPageControl()
        fillArrayWithRandomIngridients()
        
        
    }
    
 
// MARK: - Private Methods
   private func prepareCollectionVC() {
        for item in ingridients {
             DataProvider().getModel(with: item) {[weak self] model in
                self?.arrayToPresent.append(model)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
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
    
    private func fillArrayWithRandomIngridients() {
        arrayToPresent = []
        ingridients = []
        pageControl.numberOfPages = 0
        for _ in 0...5 {
            guard let element = allIngridientsForRandomize.randomElement() else { return }
            if !ingridients.contains(element) {
                ingridients.append(element)
            }
        }
        prepareCollectionVC()
    }
    
    private func setUpPageControl() {
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
    }
    
}


// MARK: - Collection View Data Source & Delegate & Flowlayout
extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = arrayToPresent.count
        return arrayToPresent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell" , for: indexPath) as? CollectionViewCell else {
            print("Cell hasn been created")
            return UICollectionViewCell()}
        let item = arrayToPresent[indexPath.item]
        let text = item.name
        //print(item)
        
        cell.collectionLabel?.text = "Cocktails with \(text)"
        if let imageUrl = item.arrayOfCocktail.first?.imageUrl {
            PictureManager.downloadImage(url: imageUrl ) { data in
                cell.backgroundImageView.image = UIImage(data: data)
                cell.gradientView.isHidden = true 
            }
        }
        
        return cell

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return calculateSizeOfCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tableVC = storyboard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
        tableVC.arrayToReuse = arrayToPresent[indexPath.item].arrayOfCocktail
        self.navigationController?.pushViewController(tableVC, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(pageNumber)
    }
}





