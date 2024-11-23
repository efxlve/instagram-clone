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
    
    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping DatabaseCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadPostImage(image: image) { imageUrl in
            let values: [String: Any] = ["caption": caption,
                                         "timestamp": Int(NSDate().timeIntervalSince1970),
                                         "likes": 0,
                                         "imageUrl": imageUrl,
                                         "ownerUid": uid,
                                         "ownerImageUrl": user.profileImageUrl,
                                         "ownerUsername": user.username]
            
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
    
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        let query = REF_POSTS.queryOrdered(byChild: "ownerUid").queryEqual(toValue: uid)
        
        query.observe(.value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            var posts = dictionaries.map({ Post(postId: $0.key, dictionary: $0.value as! [String: Any]) })
            posts.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds })
            completion(posts)
        }
    }
    
    static func likePost(post: Post, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_POSTS.child(post.postId).child("likes").setValue(post.likes + 1)
        REF_POST_LIKES.child(post.postId).updateChildValues([uid: 1]) { _,_ in
            REF_USER_LIKES.child(uid).updateChildValues([post.postId: 1], withCompletionBlock: completion)
        }
    }
    
    static func unlikePost(post: Post, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard post.likes > 0 else { return }
        REF_POSTS.child(post.postId).child("likes").setValue(post.likes - 1)
        REF_POST_LIKES.child(post.postId).child(uid).removeValue { _, _ in
            REF_USER_LIKES.child(uid).child(post.postId).removeValue()
        }
    }
    
    static func checkIfUserLikedPost(post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_LIKES.child(uid).child(post.postId).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}