//
//  PostViewModel.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 14.11.2024.
//

import Foundation

struct PostViewModel {
    private let post: Post
    
    var username: String {
        return post.ownerUsername
    }
    
    var profileImageUrl: URL? {
        return URL(string: post.ownerImageUrl)
    }
    
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var caption: String {
        return post.caption
    }
    
    var likes: Int {
        return post.likes
    }
    
    var likesLabelText: String {
        if post.likes == 0 {
            return "Be the first to like this"
        } else if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: post.timestamp.dateValue(), to: now) ?? "2m"
    }
    
    init(post: Post) {
        self.post = post
    }
}
