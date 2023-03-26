//
//  ProductsViewModel.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 23/03/2023.
//

import Foundation
import CoreData
import Reachability
import UIKit

class ProductsListViewModel {
    
    // MARK: - Properties
    
    var productService: ProductsService
    let reachability = try! Reachability()
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
    
    // Closure to update the view when the products array is modified
    var bindProductsViewModelToView: (()->()) = {}
    
    // Closure to update the view when the error message is modified
    var bindViewModelErrorToView: (()->()) = {}
    
    // MARK: - Initializers
    
    init() {
        self.productService = APIService()
        //self.fetchProductsFromAPI()
        setupReachabilityObserver()
    }
    
    init(productService: ProductsService = APIService()) {
        self.productService = productService
    }
    
    // MARK: - Methods
    
    func prefetchItems(at indexPaths: [IndexPath]) {
        for index in indexPaths {
            // Check if the user has scrolled to the last item of the current list
            if index.item >= products.count - 20 && !isFetchingProducts {
                // Fetch new products from the API
                fetchProductsFromAPI()
                break
            }
        }
    }
    
    func setupReachabilityObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        guard let reachability = notification.object as? Reachability else {
            return
        }
        if reachability.connection != .unavailable {
            // Fetch data from API
            fetchProductsFromAPI()
        } else {
            // Show no internet connection error
            errorMessage = "No internet connection"
            self.products = CoreDataService.shared.retrieveSavedProducts() ?? []
        }
    }
    
    // MARK: - Fetch Method From API
    
    func fetchProductsFromAPI() {
        isFetchingProducts = true
        if reachability.connection != .unavailable {
            productService.fetchProducts { [weak self] (result: Result<Product, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let products):
                    self.products.append(contentsOf: products.records)
                    CoreDataService.shared.saveProducts(products: products.records)
                case .failure(let error):
                    let message = error.localizedDescription
                    self.errorMessage = message
                    print(error.localizedDescription)
                }
                self.isFetchingProducts = false
            }
        } else {
            errorMessage = "No internet connection"
            isFetchingProducts = false
        }
    }
}
