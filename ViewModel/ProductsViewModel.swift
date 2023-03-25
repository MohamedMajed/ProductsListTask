////
////  ProductsViewModel.swift
////  ProductsListTask
////
////  Created by Mohamed Maged on 23/03/2023.
////
//
//import Foundation
//import CoreData
//import Reachability
//import UIKit
//
//class ProductsViewModel {
//
//    // MARK: - Properties
//
//    var productService: ProductsService
//    let reachability = try! Reachability()
//    var currentPage: Int = 1
//    var isFetchingProducts = false
//    var products: [Record] = [] {
//        didSet {
//
//            self.bindProductsViewModelToView()
//        }
//    }
//
//    var errorMessage: String = "" {
//        didSet {
//
//            self.bindViewModelErrorToView()
//        }
//    }
//
//    var bindProductsViewModelToView: (()->()) = {}
//    var bindViewModelErrorToView: (()->()) = {}
//
//    // MARK: - Initializers
//
//    init() {
//        self.productService = APIService()
//        self.fetchProductsFromAPI()
//        setupReachabilityObserver()
//    }
//
//    init(productService: ProductsService = APIService()) {
//        self.productService = productService
//    }
//
//    // MARK: - Methods
//
//    func prefetchRows(at indexPaths: [IndexPath]) {
//        for index in indexPaths {
//            // Check if the user has scrolled to the last row of the current list
//            if index.row >= products.count - 20 && !isFetchingProducts && currentPage <= 10 {
//                // Fetch new products from the API
//                fetchProductsFromAPI()
//                break
//            }
//        }
//    }
//
//    func setupReachabilityObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
//        do {
//            try reachability.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
//    }
//
//    @objc func reachabilityChanged(notification: Notification) {
//        guard let reachability = notification.object as? Reachability else {
//            return
//        }
//        if reachability.connection != .unavailable {
//            // Fetch data from API
//            fetchProductsFromAPI()
//        } else {
//            // Show no internet connection error
//            errorMessage = "No internet connection"
//        }
//    }
//
////    func fetchProductsFromAPI() {
////        isFetchingProducts = true
////        if reachability.connection != .unavailable {
////            productService.fetchProducts { [weak self] (result: Result<Product, Error>) in
////                guard let self = self else { return }
////                switch result {
////                case .success(let products):
////                    self.products.append(contentsOf: products.records)
////                case .failure(let error):
////                    let message = error.localizedDescription
////                    self.errorMessage = message
////                    print(error.localizedDescription)
////                }
////                self.isFetchingProducts = false
////            }
////            self.save(products: self.products)
////        } else {
////            errorMessage = "No internet connection"
////            isFetchingProducts = false
////            self.products = self.retrieveSavedProducts()!
////        }
////    }
//
//    func fetchProductsFromAPI() {
//        isFetchingProducts = true
//        if reachability.connection != .unavailable {
//            productService.fetchProducts { [weak self] (result: Result<Product, Error>) in
//                guard let self = self else { return }
//                switch result {
//                case .success(let products):
//                    self.products.append(contentsOf: products.records)
//                    self.save(products: products.records)
//                case .failure(let error):
//                    let message = error.localizedDescription
//                    self.errorMessage = message
//                    print(error.localizedDescription)
//                }
//                self.isFetchingProducts = false
//            }
//        } else {
//            errorMessage = "No internet connection"
//            isFetchingProducts = false
//            self.products = self.retrieveSavedProducts() ?? []
//        }
//    }
//
//
//    func save(products: [Record]) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//        for product in products {
//            let entity = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context)
//            let myProduct = NSManagedObject(entity: entity!, insertInto: context)
//            myProduct.setValue(product.description, forKey: "productDescription")
//            myProduct.setValue(product.image.url, forKey: "productImage")
//            myProduct.setValue(product.price, forKey: "productPrice")
//            myProduct.setValue(product.id, forKey: "productID")
//        }
//
//        do {
//                try context.save()
//                print("Saved Successfully")
//            } catch {
//                print("Error saving: \(error)")
//            }
//    }
//
//    func retrieveSavedProducts() -> [Record]? {
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        let context = appDelegate!.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
//        var retrievedProducts: [Record] = []
//
//        do {
//            let results = try context.fetch(fetchRequest)
//            if !results.isEmpty {
//                for result in results as! [NSManagedObject] {
//                    guard let description = result.value(forKey: "productDescription") as? String else { return nil }
//                    guard let imageURL = result.value(forKey: "productImage") as? String else { return nil }
//                    guard let price = result.value(forKey: "productPrice") as? Int else { return nil }
//                    guard let id = result.value(forKey: "productID") as? Int else { return nil }
//
//                    let image = Image(url: imageURL, width: 0, height: 0)
//                    let product = Record(id: id, image: image, price: price, description: description)
//                    retrievedProducts.append(product)
//                    print(retrievedProducts)
//                }
//            }
//        } catch {
//            print("Error retrieving: \(error)")
//        }
//        return retrievedProducts
//    }
//
//}
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

class ProductsViewModel {
    
    // MARK: - Properties
    
    var productService: ProductsService
    let reachability = try! Reachability()
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
            self.products = self.retrieveSavedProducts() ?? []
        }
    }
    
    func fetchProductsFromAPI() {
        isFetchingProducts = true
        if reachability.connection != .unavailable {
            productService.fetchProducts { [weak self] (result: Result<Product, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let products):
                    self.products.append(contentsOf: products.records)
                    self.save(products: products.records)
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
    
    //MARK: - Data Model Methods
    
    func save(products: [Record]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        for product in products {
            let entity = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context)
            let myProduct = NSManagedObject(entity: entity!, insertInto: context)
            myProduct.setValue(product.description, forKey: "productDescription")
            myProduct.setValue(product.image.url, forKey: "productImage")
            myProduct.setValue(product.price, forKey: "productPrice")
            myProduct.setValue(product.id, forKey: "productID")
        }
        
        do {
            try context.save()
            print("Saved Successfully")
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    func retrieveSavedProducts() -> [Record]? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
        var retrievedProducts: [Record] = []
        
        do {
            let results = try context.fetch(fetchRequest)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    guard let description = result.value(forKey: "productDescription") as? String else { return nil }
                    guard let imageURL = result.value(forKey: "productImage") as? String else { return nil }
                    guard let price = result.value(forKey: "productPrice") as? Int else { return nil }
                    guard let id = result.value(forKey: "productID") as? Int else { return nil }
                    
                    let image = Image(url: imageURL, width: 0, height: 0)
                    let product = Record(id: id, image: image, price: price, description: description)
                    retrievedProducts.append(product)
                    print(retrievedProducts)
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return retrievedProducts
    }
    
}
