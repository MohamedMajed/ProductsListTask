//
//  ProductsViewModel.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 23/03/2023.
//

import Foundation


class ProductsViewModel {
    
    //MARK: - Properties
    
    var productService: ProductsService
    var currentPage: Int = 1
    var isFetchingProducts = false
    var products: [Record] = [] {
        didSet {
            
            self.bindProductsViewModelToView()
        }
    }
    
    var errorMessage: String = "" {
        didSet {
            
            self.bindViewModelErrorToView()
        }
    }
    
    var bindProductsViewModelToView: (()->()) = {}
    var bindViewModelErrorToView: (()->()) = {}
    
    //MARK: - Initializers
    
    init() {
        self.productService = APIService()
        self.fetchProductsFromAPI()
    }
    
    init(productService: ProductsService = APIService()) {
        self.productService = productService
    }
    
    //MARK: - Methods
    
    func prefetchRows(at indexPaths: [IndexPath]) {
        for index in indexPaths {
            // Check if the user has scrolled to the last row of the current list
            if index.row >= products.count - 20 && !isFetchingProducts && currentPage <= 10 {
                // Fetch new products from the API
                fetchProductsFromAPI()
                break
            }
        }
    }
    
    func fetchProductsFromAPI() {
        
        isFetchingProducts = true
        productService.fetchProducts(atPage: currentPage) { [weak self] (result: Result<Product, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                if self.currentPage <= 10 {
                    self.products.append(contentsOf: products.records)
                    self.currentPage += 1
                }
            case .failure(let error):
                let message = error.localizedDescription
                self.errorMessage = message
                print(error.localizedDescription)
            }
            self.isFetchingProducts = false
        }
    }
}
