//
//  Product.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 23/03/2023.
//

import Foundation

// MARK: - Products
struct Products: Codable {
    let records: [Record]
}

// MARK: - Record
struct Record: Codable {
    let id: Int
    let image: Image
    let price: Int
    let description: String
}

// MARK: - Image
struct Image: Codable {
    let url: String
    let width, height: Int
}
