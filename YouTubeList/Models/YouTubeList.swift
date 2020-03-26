//
//  YouTubeList.swift
//  YouTubeList
//
//  Created by Admin on 3/25/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import Foundation

struct YouTubeList : Codable {
    let kind : String
    let etag : String
    let nextPageToken : String
    let items : [Video]
}

struct Video : Codable {
    let kind : String
    let etag : String
    let id : String
    let snippet : Snippet
}

struct Snippet : Codable {
    
    let publishedAt : String
    let channelId : String
    let title : String
    let description : String
    let thumbnails : Thumbnails
    let channelTitle : String
    let tags : [String]?
    let categoryId : String
    let liveBroadcastContent : String
    let localized : Localized
    
}

struct Localized  : Codable {
    
    let title : String
    let description : String
    
}

struct Thumbnails : Codable {
    
    let medium : ThumbnailsParametrs?
    let high : ThumbnailsParametrs?
    let standard : ThumbnailsParametrs?
    let maxres : ThumbnailsParametrs?
    
}

struct ThumbnailsParametrs : Codable {
    
    let url : String
    let width : Int
    let height : Int
    
}
