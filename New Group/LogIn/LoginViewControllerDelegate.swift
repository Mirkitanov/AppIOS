//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Админ on 17.02.2022.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
protocol LoginViewControllerDelegate: AnyObject {
    func creteUser(id: String, login: String?, password: String?, failure: @escaping (Errors) -> Void) -> Bool
    func checkUsers() -> [UserModel]
    func setCurrentUser (id: String)
    func resetCurrentUser (id: String)
    func saveUserProperties (id: String, userDataForSave: UserModel)
    func loadUserProperties(id: String) -> UserModel?
}
