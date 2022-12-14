//
//  MainProfileHeaderView.swift
//  Navigation
//
//  Created by Админ on 12.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class MainProfileHeaderView: UIView {
    
    // MARK:- Properties
    weak var flowCoordinator: ProfileCoordinator?
    
    private var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "person")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()
    
    private var fullNameLabel: UILabel = {
        let fullNameLabel = UILabel()
//        fullNameLabel.text = "Павел Миркитанов"
        fullNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        fullNameLabel.textColor = .black
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.sizeToFit()
        return fullNameLabel
    }()
    
    var statusTextField: UITextField = {
        let statusTextField = UITextField()
        statusTextField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        statusTextField.textColor = .black
        statusTextField.backgroundColor = .white
        statusTextField.placeholder = "Введите новый статус"
        statusTextField.borderStyle = .bezel
        statusTextField.translatesAutoresizingMaskIntoConstraints = false
        return statusTextField
    }()
    
    private var setStatusButton: UIButton = {
        let setStatusButton = UIButton()
        setStatusButton.backgroundColor = .systemBlue
        setStatusButton.setTitleColor(.white, for: .normal)
        setStatusButton.setTitle("Установить статус", for: .normal)
        setStatusButton.setTitleColor(.black, for: .highlighted)
        setStatusButton.clipsToBounds = true
        setStatusButton.layer.masksToBounds = false
        setStatusButton.layer.cornerRadius = 4
        setStatusButton.layer.shadowColor = UIColor.black.cgColor
        setStatusButton.layer.shadowOffset.width = 4
        setStatusButton.layer.shadowOffset.height = 4
        setStatusButton.layer.shadowOpacity = 0.7
        setStatusButton.layer.shadowRadius = 4
        setStatusButton.translatesAutoresizingMaskIntoConstraints = false
        setStatusButton.addTarget(self, action: #selector(setStatusButtonTapped(_:)), for: .touchUpInside)
        return setStatusButton
    }()
    
    private let statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = "Waiting for something..."
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        statusLabel.textColor = .gray
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        return statusLabel
    }()
    
    
    // MARK:- Life cycle
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK:- Actions
    
    @objc private func setStatusButtonTapped(_ sender: Any) {
        
        guard statusTextField.text != "" else {
            return
        }
        
        
        statusLabel.text = statusTextField.text
        print (statusTextField.text ?? "Нет статуса")
        statusTextField.text = ""
        
        flowCoordinator?.profileCoordinatorUserProperties?.userStatus = statusLabel.text ?? "Статус пуст"
        
        //        flowCoordinator!.profileCoordinatorUserProperties!.userStatus = statusTextField.text ?? "Статус пуст"
        
        flowCoordinator!.profileCoordinatorAuthorizationDelegate!.saveUserProperties(id: flowCoordinator!.profileCoordinatorUserProperties!.id, userDataForSave: flowCoordinator!.profileCoordinatorUserProperties!)
        
        statusLabel.text = flowCoordinator!.profileCoordinatorUserProperties!.userStatus
        print("Realm User Status")
        print(flowCoordinator!.profileCoordinatorUserProperties!.userStatus)
        
        
        
    }
    
    // MARK:- Setups
    
    private func setupViews() {
        setNeedsLayout()
        layoutIfNeeded()
        
        backgroundColor = .systemGray4
        
        addSubviews(avatarImageView,
                    fullNameLabel,
                    statusLabel,
                    statusTextField,
                    setStatusButton
        )
        
        let constraints = [
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            
            fullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 27),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            fullNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            statusLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            statusTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            statusTextField.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
            
            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 16),
            setStatusButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            setStatusButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard flowCoordinator != nil else {
            print("flowCoordinator for Header is nil")
            return
        }
        
        guard flowCoordinator?.profileCoordinatorAuthorizationDelegate != nil else {
            print("Authorization delegate for Header is nil")
            return
        }
        
        guard flowCoordinator?.profileCoordinatorUserProperties != nil else {
            print("flowCoordinator?.profileCoordinatorUserProperties for Header is nil")
            return
        }
        
        print("flowCoordinator?.profileCoordinatorAuthorizationDelegate")
        print (flowCoordinator!.profileCoordinatorAuthorizationDelegate!)
        
        statusLabel.text = flowCoordinator!.profileCoordinatorUserProperties!.userStatus
        
        fullNameLabel.text = flowCoordinator!.profileCoordinatorUserProperties!.userName
        
    }
}

