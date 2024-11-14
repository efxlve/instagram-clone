//
//  CommentService.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 14.11.2024.
//

import Firebase
import FirebaseDatabase

struct CommentService {
    static func uploadComment(comment: String, postID: String, user: User, withCompletionBlock: @escaping(Error?, DatabaseReference) -> Void) {
        
        let data = ["uid": user.uid,
                    "comment": comment,
                    "timestamp": Int(NSDate().timeIntervalSince1970),
                    "username": user.username,
                    "profileImageUrl": user.profileImageUrl] as [String : Any]
        
        REF_COMMENTS.child(postID).childByAutoId().updateChildValues(data) { error, ref in
            withCompletionBlock(error, ref)
        }
    }
    
    static func fetchComments() {
    }
        
}
