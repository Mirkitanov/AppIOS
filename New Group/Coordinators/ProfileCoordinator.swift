//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Админ on 17.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class ProfileCoordinator: FlowCoordinatorProtocol {
    
    
    var navigationController: UINavigationController
    weak var mainCoordinator: AppCoordinator?
    var profileCoordinatorHeaderView = MainProfileHeaderView()
    var profileCoordinatorAuthorizationDelegate: LoginViewControllerDelegate?
    var profileCoordinatorUserProperties: UserModel?
    
    init(navigationController: UINavigationController, mainCoordinator: AppCoordinator?) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }
    
    func start() {
        let vc = MainLogInViewController()
        vc.flowCoordinator = self
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func backtoRoot() {
        guard navigationController.viewControllers.count > 0 else { return }
        
        navigationController.popToRootViewController(animated: true)
    }
    
    func gotoProfile() {
        print("var profileCoordinatorAuthorizationDelegate: LoginViewControllerDelegate?")
        print(profileCoordinatorAuthorizationDelegate)
        
        let vc = MainProfileViewController()
        vc.flowCoordinator = self
        profileCoordinatorHeaderView.flowCoordinator = self
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func gotoPhotos() {
        let vc = PhotosViewController()
        vc.flowCoordinator = self
        
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    func gotoChangeUserName(){
        let vc = ProfileChangeUserNameViewController()
        vc.flowCoordinator = self
        vc.cancelFinalAction = nil
        vc.renameFinalAction = { [weak self] in
            self?.backtoRoot()
        }
        navigationController.present(vc, animated: true)
    }
}
