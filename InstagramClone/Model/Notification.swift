//
//  Notification.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 23.11.2024.
//

import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
            case .like: return " liked your post."
            case .follow: return " started following you."
            case .comment: return " commented on your post."
        }
    }
}

struct Notification {
    let uid: String
    var postImageUrl: String?
    var postId: String?
    let timestamp: Date!
    let type: NotificationType
    let id: String
    let userProfileImageUrl: String
    let username: String
    var userIsFollowed = false
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.timestamp = Date(timeIntervalSince1970: TimeInterval(dictionary["timestamp"] as? Int ?? 0))
        self.id = dictionary["id"] as? String ?? ""
        self.postId = dictionary["postId"] as? String
        self.postImageUrl = dictionary["postImageUrl"] as? String
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    }
}
