# Load Image With Catcher

- Loading/Downloading image from URL and save in local using catcher

     
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
