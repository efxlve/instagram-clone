//
//  ProfileHeaderViewModel.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 2.11.2024.
//

import Foundation
import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var followButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        return user.isFollowing ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        if user.isCurrentUser {
            return .systemBackground
        } else {
            return user.isFollowing ? .systemBackground : .systemBlue
        }
    }
    
    var followButtonTextColor: UIColor {
        return user.isFollowing ? .label : .white
    }
    
    init(user: User) {
        self.user = user
    }
}
