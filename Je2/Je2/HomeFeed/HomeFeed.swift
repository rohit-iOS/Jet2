//
//  HomeFeed.swift
//  Je2
//
//  Created by Rohit Karyappa on 2/26/20.
//  Copyright © 2020 Rohit Karyappa. All rights reserved.
//

import Foundation

struct TeamMembers: Codable {
    let teamMebers: [TeamMember]
    
    enum CodingKeys: String, CodingKey {
        case teamMebers = "results"
    }
}

struct TeamMember: Codable {
    let gender: String
    let name : Name
    let imageUrls : ImageUrls
    
    enum CodingKeys: String, CodingKey {
        case gender = "gender"
        case name = "name"
        case imageUrls = "picture"
    }
}


struct Name: Codable {
    let title : String
    let firstName : String
    let lastName : String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case firstName = "first"
        case lastName = "last"
    }
}

struct ImageUrls: Codable {
    let largeImageUrl : String
    let mediumImageUrl : String
    let thumbnailImageUrl : String
    
    enum CodingKeys: String, CodingKey {
        case largeImageUrl = "large"
        case mediumImageUrl = "medium"
        case thumbnailImageUrl = "thumbnail"
    }
}
