//
//  ProductsService.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 23/03/2023.
//

import Foundation


protocol ProductsService {
    func fetchProducts(/*atPage: Int,*/ completion: @escaping (Result<Product, Error>) -> Void)
}

class APIService: ProductsService {
    
    func fetchProducts(/*atPage: Int,*/ completion: @escaping (Result<Product, Error>) -> Void ) {
        let URLString = "https://api.npoint.io/d847ef26e26389465c6d".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: URLString)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        executeRequest(url: url, httpMethod: "GET", payload: nil, decoding: Product.self, using: decoder, completion: completion)
    }
    
    func executeRequest<T: Decodable>(url: URL, httpMethod: String, payload: Data?, decoding: T.Type, using decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = payload
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            do {
                if let error = error { throw error }
                
                guard let data = data else {
                    completion(.failure(APIError.dataNotFound))
                    return
                }
                let decodedModel = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedModel))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                print(error.localizedDescription)
            }
        }.resume()
    }

}
