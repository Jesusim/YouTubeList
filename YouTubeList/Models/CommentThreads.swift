//
//  CommentThreads.swift
//  YouTubeList
//
//  Created by Admin on 3/27/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import Foundation

struct CommentThreads : Codable {
    let kind : String?
    let etag : String?
    let nextPageToken : String?
    let pageInfo : PageInfo?
    let items : [Comment]?
}

struct Comment : Codable {
    let kind : String?
    let etag : String?
    let id : String?
    let snippet :  CommentSnippet?
}

struct CommentSnippet : Codable {
    let videoId : String?
    let topLevelComment : TopComment?
    
    //  This fields are used in getAnswerComment
    let authorDisplayName : String?
    let authorProfileImageUrl : String?
    let textDisplay : String?
}

struct TopComment : Codable {
    let kind : String?
    let etag : String?
    let id : String?
    let snippet : UserInfoDSnippet?
}

// Tread comment fields
struct UserInfoDSnippet : Codable {
    
    let authorDisplayName : String?
    let authorProfileImageUrl : String?
    let textDisplay : String?
    let publishedAt : String?
    
}

