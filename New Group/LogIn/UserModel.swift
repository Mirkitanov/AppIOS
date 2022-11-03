//
//  User.swift
//  Navigation
//
//  Created by Админ on 15.09.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//  ХВ

import Foundation

struct UserModel {
    var id: String
    var login: String
    var password: String
    var isCurrentUser: Bool
    var userStatus: String
    var userName: String
    var currentUserStorage: StorageModel
    var userContentArray : [(image: String, name: String, likes: String, views: String, description: String?)] = []
    
    init(id: String, login: String, password: String, isCurrentUser: Bool, userStatus: String, userName: String, currentUserStorage: StorageModel, userContentArray : [(image: String, name: String, likes: String, views: String, description: String?)]) {
        self.id = id
        self.login = login
        self.password = password
        self.isCurrentUser = isCurrentUser
        self.userStatus = userStatus
        self.userName = userName
        self.currentUserStorage = currentUserStorage
        self.userContentArray = userContentArray
    }
}
