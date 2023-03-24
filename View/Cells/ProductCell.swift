//
//  ProductCell.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 23/03/2023.
//

import UIKit
import Kingfisher

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var descriptionLebel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Configure Collection View cell
    
    func configureCell(productDescription: String, productPrice: Int, productImage: String, widthOfImg: Int, heightOfImg: Int) {
        descriptionLebel.text = productDescription
        priceLabel.text = "\(productPrice) EGP"
        let url = URL(string: productImage)
        productImg.kf.setImage(with: url)
    }

}
 
