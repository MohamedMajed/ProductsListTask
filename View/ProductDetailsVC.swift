//
//  ProductDetailsVC.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 24/03/2023.
//

import UIKit
import Kingfisher


class ProductDetailsVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    
    // MARK: - Properties
    var productDetailsViewModel: ProductDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    // MARK: - Private Methods
    
    func configureView() {
        productImage.kf.setImage(with: URL(string: productDetailsViewModel!.productImageUrl))
        productDescription.text = productDetailsViewModel?.productDescription
    }
}

