//
//  ImageSearchEngine.swift
//  RemoteImageGallery
//
//  Created by Nilay Moradiya on 22/07/22.
//

import Foundation

protocol ImageSearchEngine {
    func searchImage(_ query: String, completion: @escaping ((Result<[RemoteImage],Error>) -> ()))
}

struct DefaultImageSearchEngine: ImageSearchEngine {
    
    func makeURL(_ query: String) -> URL {
        let queryString = query.replacingOccurrences(of: " ", with: "+")
        let domainURL = URL(string: "https://pixabay.com/api/")!
        return domainURL
            .appending("key", value: "13197033-03eec42c293d2323112b4cca6")
            .appending("q", value: queryString) // query
            .appending("image_type", value: "photo")
            .appending("per_page", value: "50")
    }
    
    func searchImage(_ query: String, completion: @escaping ((Result<[RemoteImage],Error>) -> ())) {
        let url = makeURL(query)
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                do {
                    let result = try JSONDecoder().decode(ImagesDataResponse.self, from: data!)
                    completion(.success(result.hits))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
