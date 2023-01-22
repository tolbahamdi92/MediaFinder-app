//
//  MediaResults.swift
//  MediaFinder
//
//  Created by Tolba on 22/06/1444 AH.
//

import Foundation

struct MediaResults: Codable {
    var resultCount: Int!
    var results: [Media]!
}

struct Media: Codable {
    var artistName: String?
    var artworkUrl: String!
    var trackName: String?
    var longDescription: String?
    var previewUrl: String!
    
    enum CodingKeys: String, CodingKey {
    case artistName, trackName, longDescription, previewUrl
        case artworkUrl = "artworkUrl100"
    }
}
