//
//  FImage.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import Foundation

struct FImage: Codable, Hashable {
    let title: String
    let link: String
    let description: String
    let modified: Date
    let generator: String
    let items: [Item]
}

struct Item: Codable, Hashable {
    let title: String
    let link: String
    let media: Media
    let dateTaken: Date
    let description: String
    let published: Date
    let author: String
    let tags: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, media
        case dateTaken = "date_taken"
        case description, published, author, tags
    }
}

struct Media: Codable, Hashable {
    let m: String
}

