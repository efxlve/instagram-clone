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
    
    static func fetchPost(withPostId postId: String, completion: @escaping(Post) -> Void) {
        REF_POSTS.child(postId).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let post = Post(postId: postId, dictionary: dictionary)
            completion(post)
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
    
    static func fetchFeedPosts(completion: @escaping([Post]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var posts = [Post]()
        
        REF_USER_FEED.child(uid).observe(.value) { snapshot in
            snapshot.children.allObjects.forEach { child in
                fetchPost(withPostId: (child as! DataSnapshot).key) { post in
                    posts.append(post)
                    completion(posts)
                }
            }
        }
    }
    
    static func updateUserFeedAfterFollowing(user: User) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = REF_POSTS.queryOrdered(byChild: "ownerUid").queryEqual(toValue: user.uid)
        query.observeSingleEvent(of: .value) { snapshot, error in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { key, value in
                REF_USER_FEED.child(uid).child(key).updateChildValues(value as! [String: Any])
            }
        }
    }
}
