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
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictionary["id"] as? String ?? ""
        self.postId = dictionary["postId"] as? String
        self.postImageUrl = dictionary["postImageUrl"] as? String
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
    }
}
