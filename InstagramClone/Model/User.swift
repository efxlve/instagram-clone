//
//  User.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 2.11.2024.
//

import Foundation
import FirebaseAuth

struct User {
    let email: String
    let fullname: String
    let profileImageUrl: String
    let username: String
    let uid: String
    
    var isFollowing = false
    
    var stats: UserStats!
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        
        if let stats = dictionary["stats"] as? [String: Int] {
            self.stats = UserStats(followers: stats["followers"] ?? 0, following: stats["following"] ?? 0)
        } else {
            self.stats = UserStats(followers: 0, following: 0)
        }
    }
}

struct UserStats {
    var followers: Int
    var following: Int
}
