//
//  ImageCollectionViewCell.swift
//  RemoteImageGallery
//
//  Created by Nilay Moradiya on 22/07/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleImageView: UIImageView!
    
    func configure(item: RemoteImage) {
        titleImageView.loadImage(with: item.imageURL, placeholder: UIImage(named: "loadingIcon"))
    }
    
}
