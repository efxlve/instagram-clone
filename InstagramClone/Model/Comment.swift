//
//  Comment.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 15.11.2024.
//

import Firebase

struct Comment {
    let uid: String
    let username: String
    let profileImageUrl: String
    var timestamp: Date!
    let commentText: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.commentText = dictionary["comment"] as? String ?? ""
        self.timestamp = Date(timeIntervalSince1970: TimeInterval(dictionary["timestamp"] as? Int ?? 0))
    }
}
