//
//  Constants.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 30.10.2024.
//

import Firebase
import FirebaseStorage

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let REF_DB = Database.database().reference()
let REF_USERS = REF_DB.child("users")

let REF_FOLLOWING = REF_DB.child("following")
let REF_FOLLOWERS = REF_DB.child("followers")

let REF_NOTIFICATIONS = REF_DB.child("notifications")
let REF_LIKES = REF_DB.child("likes")
let REF_POSTS = REF_DB.child("posts")
let REF_COMMENTS = REF_DB.child("comments")

let REF_POST_LIKES = REF_DB.child("post-likes")
let REF_USER_LIKES = REF_DB.child("user-likes")

let REF_USER_FEED = REF_DB.child("user-feed")

