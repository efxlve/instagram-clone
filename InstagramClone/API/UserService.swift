//
//  UserService.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 2.11.2024.
//

import Firebase
import FirebaseAuth

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        REF_USERS.observe(.value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            let users = dictionaries.map({ User(uid: $0.key, dictionary: $0.value as! [String: Any]) })
            completion(users)
        }
    }
    
    static func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { error, ref in
            REF_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    static func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_FOLLOWING.child(currentUid).child(uid).removeValue { error, ref in
            REF_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
}