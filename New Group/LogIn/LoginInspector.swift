//
//  LoginInspector.swift
//  Navigation
//
//  Created by Админ on 15.09.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//  ХВ

import Foundation
import RealmSwift

@objcMembers class CachedUser: Object {
    dynamic var id: String?
    dynamic var login: String?
    dynamic var password: String?
    dynamic var isCurrentUser: Bool = false
    
    dynamic var userStatus: String?
    dynamic var userName: String?
    dynamic var currentUserStorage = StorageModel(tableModel: [])
    dynamic var userContentArray : [(image: String, name: String, likes: String, views: String, description: String?)] = []
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class LoginInspector: LoginViewControllerDelegate {
    
    private var realm: Realm? {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("users.realm")
        return try? Realm(configuration: config)
    }
    
    //:- Проверка Пользователей
    func checkUsers() -> [UserModel] {
        return realm?.objects(CachedUser.self).compactMap {
            guard let id = $0.id, let login = $0.login, let password = $0.password
            else { return nil }
            
            return UserModel(id: id, login: login, password: password, isCurrentUser: $0.isCurrentUser, userStatus: $0.userStatus ?? "Нет статуса", userName: $0.userName ?? login, currentUserStorage: $0.currentUserStorage, userContentArray: $0.userContentArray  )
        } ?? []
    }
    
    //:- Создание Пользователя
    func creteUser(id: String, login: String?, password: String?, failure: @escaping (Errors) -> Void) -> Bool {
        
        if login == "" && password == ""  {
            
            failure(.noData)
            return false
            
        } else if login == nil || login == "" {
            
            failure(.incorrectEmail)
            return false
            
        } else if password == nil || password == "" {
            
            failure(.incorrectData)
            return false
            
        } else if password!.count < 6 {
            
            failure(.shortPassword)
            return false
            
        } else {
            
            let user = CachedUser()
            user.id = id
            user.login = login
            user.password = password
            user.isCurrentUser = true
            user.userStatus = "Hello world!"
            user.userName = login
            user.currentUserStorage = StorageModel(tableModel: [])
            user.userContentArray = []
            
            try? realm?.write {
                realm?.add(user)
            }
            return true
        }
    }
    
    //:- Установка флага "Текущий Пользователь"
    func setCurrentUser (id: String){
        
        guard let user = realm?.object(ofType: CachedUser.self, forPrimaryKey: id ) else {
            return
        }
        
        try? realm?.write({
            user.isCurrentUser = true
            print("Curent user is fixed")
            
        })
    }
    
    //:- Сброс флага "Текущий Пользователь"
    func resetCurrentUser (id: String){
        
        guard let user = realm?.object(ofType: CachedUser.self, forPrimaryKey: id ) else {
            return
        }
        
        try? realm?.write({
            user.isCurrentUser = false
            print("Curent user is reset")
        })
    }
   
    //:- Сохранение свойств Пользователя
    func saveUserProperties (id: String, userDataForSave: UserModel) {
        
        guard let user = realm?.object(ofType: CachedUser.self, forPrimaryKey: id ) else {
            return
        }
        
        try? realm?.write({
            
            user.userStatus = userDataForSave.userStatus
            user.userName = userDataForSave.userName
            user.currentUserStorage.tableModel = userDataForSave.currentUserStorage.tableModel
            user.userContentArray = userDataForSave.userContentArray
            
        })
        
    }
    
    //:- Загрузка свойств Пользователя
    func loadUserProperties(id: String) -> UserModel? {
        
        guard let user = realm?.object(ofType: CachedUser.self, forPrimaryKey: id ) else {
            return nil
        }
        
        guard let id = user.id, let login = user.login, let password = user.password
        else { return nil }
        
        return UserModel(id: id, login: login, password: password, isCurrentUser: user.isCurrentUser, userStatus: user.userStatus ?? "Нет статуса", userName: user.userName ?? login, currentUserStorage: user.currentUserStorage, userContentArray: user.userContentArray)
        
    }
}
