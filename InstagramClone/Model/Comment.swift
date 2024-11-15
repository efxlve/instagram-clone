//
//  Comment.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 15.11.2024.
//

import Firebase

struct Comment {
    let id: String
    let username: String
    let profileImageUrl: String
    let timestamp: Timestamp
    let comment: String
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.comment = dictionary["comment"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
