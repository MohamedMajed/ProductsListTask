//
//  ProductsCollectionVC.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 23/03/2023.
//

import UIKit

private let reuseIdentifier = "Cell"

class ProductsCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var photo: UIImage?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    private let productViewModel = ProductsViewModel()
    var record: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startActivityIndicator()
        
        photo = UIImage(named: "Avengers")
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        collectionView.register(UINib(nibName: "ProductCell", bundle: .main), forCellWithReuseIdentifier: "ProductCell")
        // configureCollectionView()
        subscribeToViewModelEvents()
        
    }
    
    // MARK: - Subscribe to the view model events
    
    private func subscribeToViewModelEvents() {
        
        productViewModel.bindProductsViewModelToView = { [weak self] in
            self?.onSuccessUpdateView()
        }
        
        productViewModel.bindViewModelErrorToView = { [weak self] in
            self?.showErrorAlert()
        }
    }
    
    //MARK: - Update Collection View
    
    // Update the collection view when the data is successfully retrieved from the API
    private func onSuccessUpdateView() {
        
        collectionView.reloadData()
        stopActivityIndicator()
    }
    
    // Show an error alert if there was an error retrieving the data
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error 404", message: productViewModel.errorMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) {
            (UIAlertAction) in
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func startActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.darkGray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return productViewModel.products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: ProductCell.self, for: indexPath)
        
        let product = productViewModel.products[indexPath.row]
        
        cell.configureCell(productDescription: product.description, productPrice: product.price, productImage: product.image.url, widthOfImg: product.image.width, heightOfImg: product.image.height)
        cell.backgroundColor = .red
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Declare productDetailsViewModel variable
        let productDetailsViewModel = ProductDetailsViewModel(record: productViewModel.products[indexPath.item])

        // Instantiate ProductDetailsVC with productDetailsViewModel
        let productDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        productDetailsVC.productDetailsViewModel = productDetailsViewModel
        
        // Push view controller onto navigation stack
        navigationController?.pushViewController(productDetailsVC, animated: true)
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
        //return CGSize(width: self.view.frame.width * 0.493, height: self.view.frame.width * 0.60)
        return CGSize(width: collectionView.frame.size.width/2.15, height: collectionView.frame.size.height/3.1)
    }
    
    func collectionView(_ collectionView: UICollectionView , layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView , layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView , layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
    }
    
    
}
