//
//  CoreDataService.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 26/03/2023.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    
    // Singleton instance
    static let shared = CoreDataService()
    
    // Get the app delegate to access the Core Data stack
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // Get the managed object context from the app delegate
    private lazy var context: NSManagedObjectContext = {
        return appDelegate!.persistentContainer.viewContext
    }()
    
    
    // Save an array of products to Core Data
    func saveProducts(products: [Record]) {
        for product in products {
            let entity = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context)!
            let myProduct = NSManagedObject(entity: entity, insertInto: context)
            myProduct.setValue(product.description, forKey: "productDescription")
            myProduct.setValue(product.image.url, forKey: "productImage")
            myProduct.setValue(product.price, forKey: "productPrice")
            myProduct.setValue(product.id, forKey: "productID")
        }
        // Save the changes to Core Data
        do {
            try context.save()
            print("Saved Successfully")
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    // Retrieve an array of saved products from Core Data
    func retrieveSavedProducts() -> [Record]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
        var retrievedProducts: [Record] = []
        
        do {
            let results = try context.fetch(fetchRequest)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    // Get the properties of the managed object
                    guard let description = result.value(forKey: "productDescription") as? String else { return nil }
                    guard let imageURL = result.value(forKey: "productImage") as? String else { return nil }
                    guard let price = result.value(forKey: "productPrice") as? Int else { return nil }
                    guard let id = result.value(forKey: "productID") as? Int else { return nil }
                    
                    // Create a new record object from the managed object properties
                    let image = Image(url: imageURL, width: 0, height: 0)
                    let product = Record(id: id, image: image, price: price, description: description)
                    retrievedProducts.append(product)
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return retrievedProducts
    }
}
