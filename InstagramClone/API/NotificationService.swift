//
//  NotificationService.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 24.11.2024.
//

import Firebase
import FirebaseAuth

struct NotificationService {
    
    static func uploadNotification(toUid uid: String, fromUser: User, type: NotificationType, post: Post? = nil, completion: ((Error?) -> Void)? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            completion?(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated."]))
            return
        }
        guard uid != currentUid else {
            completion?(nil)
            return
        }
        
        let ref = REF_NOTIFICATIONS.child(uid)
        
        var data: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                   "uid": fromUser.uid,
                                   "type": type.rawValue,
                                   "id": ref.key as Any,
                                   "userProfileImageUrl": fromUser.profileImageUrl,
                                   "username": fromUser.username]
        
        if let post = post {
            data["postImageUrl"] = post.imageUrl
            data["postId"] = post.postId
        }
        
        ref.childByAutoId().updateChildValues(data) { error, _ in
            if let error = error {
                print("DEBUG: Error uploading notification:  \(error.localizedDescription)")
            }
            completion?(error)
        }
    }
    
    static func fetchNotifications(completion: @escaping ([Notification]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let ref = REF_NOTIFICATIONS.child(currentUid)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            let notifications = dictionaries.compactMap { key, value -> Notification? in
                guard let dictionary = value as? [String: Any] else { return nil }
                return Notification(uid: currentUid, dictionary: dictionary)
            }
            
            completion(notifications)
        }
    }
}
