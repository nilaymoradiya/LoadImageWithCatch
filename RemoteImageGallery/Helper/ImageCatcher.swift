//
//  ImageCatcher.swift
//  RemoteImageGallery
//
//  Created by Nilay Moradiya on 22/07/22.
//

import UIKit


protocol AsyncImageLoader {
    func loadImage(with urlString: String?, placeholder: UIImage?)
}

extension UIImageView: AsyncImageLoader {
    func loadImage(with urlString: String?, placeholder: UIImage?) {
        loadImageAsync(with: urlString, placeholder: placeholder)
    }
}

class ImageCatcher {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol?
    
    static let shared = ImageCatcher()
    
    private init() {
        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer!)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}


extension UIImageView {
    private static var taskKey = 0
    private static var urlKey = 0

    private var currentTask: URLSessionTask? {
        get { objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var currentURL: URL? {
        get { objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    fileprivate func loadImageAsync(with urlString: String?, placeholder: UIImage? = nil) {
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        self.image = placeholder
        guard let urlString = urlString else { return }
        if let cachedImage = ImageCatcher.shared.image(forKey: urlString) {
            self.image = cachedImage
            return
        }

        // download
        let url = URL(string: urlString)!
        currentURL = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil
            if let error = error {
                if (error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorCancelled {
                    return
                }
                print(error)
                return
            }

            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("unable to extract image")
                return
            }

            ImageCatcher.shared.save(image: downloadedImage, forKey: urlString)

            if url == self?.currentURL {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }
        currentTask = task
        task.resume()
    }
}
