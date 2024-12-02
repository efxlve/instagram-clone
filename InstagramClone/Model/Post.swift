//
//  Post.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 14.11.2024.
//

import Firebase

struct Post {
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timestamp: Date!
    let postId: String
    var ownerImageUrl: String = ""
    var ownerUsername: String = ""
    var didLike = false
    
    init(postId: String, dictionary: [String: Any]) {
        self.postId = postId
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = Date(timeIntervalSince1970: TimeInterval(dictionary["timestamp"] as? Int ?? 0))
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    }
}
