//
//  PostService.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 11.11.2024.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, completion: @escaping DatabaseCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadPostImage(image: image) { imageUrl in
            let values: [String: Any] = ["caption": caption,
                                         "timestamp": Int(NSDate().timeIntervalSince1970),
                                         "likes": 0,
                                         "imageUrl": imageUrl,
                                         "ownerUid": uid]
            
            REF_POSTS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        REF_POSTS.observe(.value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            let posts = dictionaries.map({ Post(postId: $0.key, dictionary: $0.value as! [String: Any]) })
            completion(posts)
        }
    }
}
