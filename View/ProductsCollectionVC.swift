//
//  ProductsCollectionVC.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 23/03/2023.
//

import UIKit

private let reuseIdentifier = "Cell"

class ProductsCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photo = UIImage(named: "Avengers")
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        collectionView.register(UINib(nibName: "ProductCell", bundle: .main), forCellWithReuseIdentifier: "ProductCell")
        
    }
    
    // MARK: - Configure CollectionView
    
    func configureCollectionView() {
        collectionView.register(cellType: ProductCell.self)
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: ProductCell.self, for: indexPath)
        
        cell.configureCell(productDescription: "BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla", productPrice: 354)
        cell.backgroundColor = .red
        
        return cell
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.alpha = 0.0
        cell.layer.transform = CATransform3DMakeScale(0.25, 0.25, 0.25)
        UIView.animate(withDuration: 0.25) {
            cell.contentView.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        }
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width * 0.493, height: self.view.frame.width * 0.45)
    }
    
    func collectionView(_ collectionView: UICollectionView , layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView , layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView , layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
    }
    
    
}
