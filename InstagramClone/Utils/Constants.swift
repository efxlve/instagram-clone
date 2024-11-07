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
