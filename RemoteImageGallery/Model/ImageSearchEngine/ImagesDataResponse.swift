//
//  ImagesDataResponse.swift
//  RemoteImageGallery
//
//  Created by Nilay Moradiya on 22/07/22.
//

import Foundation

// MARK: - ImagesDataResponse
struct ImagesDataResponse: Codable {
    let hits: [RemoteImage]
}

// MARK: - RemoteImage
struct RemoteImage: Codable {
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "largeImageURL"
    }
}
