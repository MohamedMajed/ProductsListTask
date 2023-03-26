//
//  DataModelService.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 26/03/2023.
//

import Foundation
import CoreData
import UIKit


class CoreDataService {
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

    func saveProducts(products: [Record]) -> Void {
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
}
////
////  CoreDataService.swift
////  ProductsListTask
////
////  Created by Mohamed Maged on 26/03/2023.
////
//
//import Foundation
//import CoreData
//import UIKit
//
//class CoreDataService {
//
//    static let shared = CoreDataService()
//
//    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
//
//    private lazy var context: NSManagedObjectContext = {
//        return appDelegate!.persistentContainer.viewContext
//    }()
//
//    func saveProducts(products: [Record]) {
//        for product in products {
//            let entity = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context)!
//            let myProduct = NSManagedObject(entity: entity, insertInto: context)
//            myProduct.setValue(product.description, forKey: "productDescription")
//            myProduct.setValue(product.image.url, forKey: "productImage")
//            myProduct.setValue(product.price, forKey: "productPrice")
//            myProduct.setValue(product.id, forKey: "productID")
//        }
//
//        do {
//            try context.save()
//            print("Saved Successfully")
//        } catch {
//            print("Error saving: \(error)")
//        }
//    }
//
//    func retrieveSavedProducts() -> [Record]? {
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
//                }
//            }
//        } catch {
//            print("Error retrieving: \(error)")
//        }
//        return retrievedProducts
//    }
//}
//import Foundation
//import CoreData
//import UIKit
//
//protocol DataModelService {
//
//    func saveProducts(completion: @escaping (Result<Product, Error>) -> Void)
//    func retrieveSavedProducts(completion: @escaping (Result<Product, Error>) -> [Record])
//}
//
//class CoreDataService: DataModelService {
//    func retrieveSavedProducts(completion: @escaping (Result<Product, Error>) -> [Record]) {
//
//                let appDelegate = UIApplication.shared.delegate as? AppDelegate
//                let context = appDelegate!.persistentContainer.viewContext
//                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
//                var retrievedProducts: [Record] = []
//
//                do {
//                    let results = try context.fetch(fetchRequest)
//                    if !results.isEmpty {
//                        for result in results as! [NSManagedObject] {
//                            guard let description = result.value(forKey: "productDescription") as? String else { return nil }
//                            guard let imageURL = result.value(forKey: "productImage") as? String else { return nil }
//                            guard let price = result.value(forKey: "productPrice") as? Int else { return nil }
//                            guard let id = result.value(forKey: "productID") as? Int else { return nil }
//
//                            let image = Image(url: imageURL, width: 0, height: 0)
//                            let product = Record(id: id, image: image, price: price, description: description)
//                            retrievedProducts.append(product)
//                            print(retrievedProducts)
//                        }
//                    }
//                } catch {
//                    print("Error retrieving: \(error)")
//                }
//                return retrievedProducts
//    }
//
//    func saveProducts(completion: @escaping (Result<Product, Error>) -> Void) {
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//            let context = appDelegate.persistentContainer.viewContext
//            for product in products {
//                let entity = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context)
//                let myProduct = NSManagedObject(entity: entity!, insertInto: context)
//                myProduct.setValue(product.description, forKey: "productDescription")
//                myProduct.setValue(product.image.url, forKey: "productImage")
//                myProduct.setValue(product.price, forKey: "productPrice")
//                myProduct.setValue(product.id, forKey: "productID")
//            }
//
//            do {
//                try context.save()
//                print("Saved Successfully")
//            } catch {
//                print("Error saving: \(error)")
//            }
//
//    }
//}
