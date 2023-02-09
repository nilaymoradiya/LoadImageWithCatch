//
//  GallaryViewController.swift
//  RemoteImageGallery
//
//  Created by Nilay Moradiya on 22/07/22.
//

import UIKit

class GallaryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [RemoteImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpComponents()
    }
    
    func setUpComponents() {
        setUpCollectionViewLayout()
    }
    
    func setUpCollectionViewLayout() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let numberOfCellsPerRow: CGFloat = 3
            let horizontalSpacing = flowLayout.minimumInteritemSpacing
            let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
    }
}

extension GallaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = images[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.configure(item: item)
        return cell
    }
}
