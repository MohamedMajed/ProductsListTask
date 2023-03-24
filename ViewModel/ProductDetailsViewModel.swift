//
//  ProductDetailsViewModel.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 24/03/2023.
//

import Foundation

class ProductDetailsViewModel {
    
    // MARK: - Properties
    
    private let record: Record
    
    var productImageUrl: String {
        return record.image.url ?? ""
    }
    
    var productDescription: String {
        return record.description ?? ""
    }
    
    // MARK: - Initializer

    init(record: Record) {
        self.record = record
    }
}
