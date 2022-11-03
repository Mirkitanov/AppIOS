//
//  ProfileChangeUserNameViewController.swift
//  Navigation
//
//  Created by Админ on 31.10.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class ProfileChangeUserNameViewController: UIViewController {
    
    // MARK:- Properties
    
    weak var flowCoordinator: ProfileCoordinator?
    
    var cancelFinalAction: (() -> Void)?
    var renameFinalAction: (() -> Void)?
    
    private let staticTextLabel: UILabel = {
        let staticTextLabel = UILabel()
        staticTextLabel.text = "Действующее имя Пользователя"
        staticTextLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        staticTextLabel.textColor = .gray
        staticTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return staticTextLabel
    }()
    
    private var currentUserNameLabel: UILabel = {
        let currentUserNameLabel = UILabel()
        currentUserNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        currentUserNameLabel.textColor = .black
        currentUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        currentUserNameLabel.sizeToFit()
        currentUserNameLabel.isUserInteractionEnabled = true
        return currentUserNameLabel
    }()
    
    var changeUserNameTextField: UITextField = {
        let changeUserNameTextField = UITextField()
        changeUserNameTextField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        changeUserNameTextField.textColor = .black
        changeUserNameTextField.backgroundColor = .white
        changeUserNameTextField.placeholder = "Введите новое имя"
        changeUserNameTextField.borderStyle = .bezel
        changeUserNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return changeUserNameTextField
    }()
    
    private var setUserNameButton: UIButton = {
        let setUserNameButton = UIButton()
        setUserNameButton.backgroundColor = .systemBlue
        setUserNameButton.setTitleColor(.white, for: .normal)
        setUserNameButton.setTitle("Установить новое имя", for: .normal)
        setUserNameButton.setTitleColor(.black, for: .highlighted)
        setUserNameButton.clipsToBounds = true
        setUserNameButton.layer.masksToBounds = false
        setUserNameButton.layer.cornerRadius = 4
        setUserNameButton.layer.shadowColor = UIColor.black.cgColor
        setUserNameButton.layer.shadowOffset.width = 4
        setUserNameButton.layer.shadowOffset.height = 4
        setUserNameButton.layer.shadowOpacity = 0.7
        setUserNameButton.layer.shadowRadius = 4
        setUserNameButton.translatesAutoresizingMaskIntoConstraints = false
        setUserNameButton.addTarget(self, action: #selector(setUserNameButtonTapped(_:)), for: .touchUpInside)
        return setUserNameButton
    }()

    // MARK:- Live circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK:- Actions
    
    @objc private func setUserNameButtonTapped(_ sender: Any) {
        
        guard changeUserNameTextField.text != "", changeUserNameTextField.text != " " else {
            return
        }
        
        let alertController = UIAlertController(title: "Вы желаете сменить Имя Пользователя?", message: "Действующее имя Пользователя будет изменено", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            print("Отмена")
            if let nvc = self.navigationController {
                // if it use navigation controller, just pop ViewController
                nvc.popViewController(animated: true)
            } else {
                // otherwise, dismiss it
                self.dismiss(animated: true, completion: nil)
            }
            self.cancelFinalAction?()
            
        }
        
        let renameAction = UIAlertAction(title: "Переименовать", style: .destructive) { [self] _ in
            print("Пользователь переименован")
            
            currentUserNameLabel.text = changeUserNameTextField.text
            print (currentUserNameLabel)
            changeUserNameTextField.text = ""
            
            flowCoordinator?.profileCoordinatorUserProperties?.userName = currentUserNameLabel.text ?? "Нет имени"

            flowCoordinator!.profileCoordinatorAuthorizationDelegate!.saveUserProperties(id: flowCoordinator!.profileCoordinatorUserProperties!.id, userDataForSave: flowCoordinator!.profileCoordinatorUserProperties!)

            print("Realm User Name")
            print(flowCoordinator!.profileCoordinatorUserProperties!.userName)
            
            if let nvc = self.navigationController {
                // if it use navigation controller, just pop ViewController
                nvc.popViewController(animated: true)
            } else {
                // otherwise, dismiss it
                self.dismiss(animated: true, completion: nil)
            }
            self.renameFinalAction?()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(renameAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK:- Setups
    
    private func setupViews() {
        
        currentUserNameLabel.text = flowCoordinator?.profileCoordinatorUserProperties?.userName
        
        view.backgroundColor = .white
        
        view.addSubviews(staticTextLabel,
                         currentUserNameLabel,
                         changeUserNameTextField,
                         setUserNameButton)
        
        let constraints = [
            
            currentUserNameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            currentUserNameLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -100),
            
            
            staticTextLabel.bottomAnchor.constraint(equalTo: currentUserNameLabel.topAnchor, constant: -27),
            staticTextLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            changeUserNameTextField.topAnchor.constraint(equalTo: currentUserNameLabel.bottomAnchor, constant: 27),
            changeUserNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            changeUserNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            
            setUserNameButton.topAnchor.constraint(equalTo: changeUserNameTextField.bottomAnchor, constant: 27),
            setUserNameButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            setUserNameButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
