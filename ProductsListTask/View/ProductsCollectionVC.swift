//
//  ProductsCollectionVC.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 23/03/2023.
//


import UIKit

private let reuseIdentifier = "Cell"

class ProductsCollectionVC: UICollectionViewController {
    
    
    // MARK: - Properties
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    private let productsListViewModel = ProductsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startActivityIndicator()
        // self.clearsSelectionOnViewWillAppear = false
        configureCollectionView()
        collectionView.isPrefetchingEnabled = true
        // configureCollectionView()
        subscribeToViewModelEvents()
    }
    
    // MARK: - Configure Collection View
    
    func configureCollectionView() {
        
        collectionView.prefetchDataSource = self
        // Register cell classes
        collectionView.register(UINib(nibName: "ProductCell", bundle: .main), forCellWithReuseIdentifier: "ProductCell")
        
    }
    
    // MARK: - Subscribe to the view model events
    
    private func subscribeToViewModelEvents() {
        
        productsListViewModel.bindProductsViewModelToView = { [weak self] in
            self?.onSuccessUpdateView()
        }
        
        productsListViewModel.bindViewModelErrorToView = { [weak self] in
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
        let alert = UIAlertController(title: "Error 404", message: productsListViewModel.errorMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) {
            (UIAlertAction) in
        }
        
        alert.addAction(action)
        //self.present(alert, animated: true, completion: nil)
        print("No Internet Connection")
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
        return productsListViewModel.products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: ProductCell.self, for: indexPath)
        
        let product = productsListViewModel.products[indexPath.row]
        
        cell.configureCell(productDescription: product.description, productPrice: product.price, productImage: product.image.url, widthOfImg: product.image.width, heightOfImg: product.image.height)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Declare productDetailsViewModel variable
        let productDetailsViewModel = ProductDetailsViewModel(record: productsListViewModel.products[indexPath.item])
        
        // Instantiate ProductDetailsVC with productDetailsViewModel
        let productDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        productDetailsVC.productDetailsViewModel = productDetailsViewModel
        
        // Push view controller onto navigation stack
        navigationController?.pushViewController(productDetailsVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductsCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - 15) / 2
        let itemHeight = itemWidth * 1.35
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
}

// MARK: UICollectionViewDataSource

extension ProductsCollectionVC: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        productsListViewModel.prefetchItems(at: indexPaths)
    }
}
