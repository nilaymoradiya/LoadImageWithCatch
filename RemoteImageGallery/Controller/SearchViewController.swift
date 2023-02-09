//
//  SearchViewController.swift
//  RemoteImageGallery
//
//  Created by Nilay Moradiya on 22/07/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTextBGView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    var imageSearchEngine: ImageSearchEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpComponents()
    }
    
    func setUpUI() {
        searchButton.addBorderAndColor(color: .white, width: 0.5, corner_radius: 12)
        searchTextBGView.addBorderAndColor(color: .black, width: 0.5, corner_radius: 18)
    }
    
    func setUpComponents() {
        addTapGestureForMisTouch()
        
        imageSearchEngine = DefaultImageSearchEngine()
    }
    
    func addTapGestureForMisTouch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func performSearch() {
        guard let query = searchTextField.text, !query.isEmpty else {
            showError(description: "Search text is empty!!!")
            return
        }
        self.showActivityIndicator()
        imageSearchEngine.searchImage(query) { [weak self] result in
            self?.hideActivityIndicator()
            switch result {
            case .success(let images):
                self?.moveToGallaryViewController(with: images)
            case .failure(let error):
                self?.showError(description: error.localizedDescription)
            }
        }
    }
    
    func moveToGallaryViewController(with remoteImages: [RemoteImage]) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GallaryViewController") as! GallaryViewController
        vc.images = remoteImages
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchButtonDidTapped(_ sender: Any) {
        performSearch()
    }
    
}
