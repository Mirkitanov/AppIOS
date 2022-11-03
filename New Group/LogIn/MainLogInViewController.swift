//  Доработка 3
//  MainLogInViewController.swift
//  Navigation
//
//  Created by Админ on 17.02.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//
import UIKit

class MainLogInViewController: UIViewController {
    
    weak var flowCoordinator: ProfileCoordinator?
    
    var authorizationDelegate: LoginViewControllerDelegate?
    
    var currentUserIndex: Int?
    
    var fixingUserProperties: UserModel?
    
    var tempStorage = StorageModel(tableModel: [])
    
    var tempUserContentArray : [(image: String, name: String, likes: String, views: String, description: String?)] = []
    
    var logInScrollView: UIScrollView = {
        let logInScrollView = UIScrollView()
        logInScrollView.translatesAutoresizingMaskIntoConstraints = false
        logInScrollView.contentInsetAdjustmentBehavior = .automatic
        logInScrollView.backgroundColor = .white
        return logInScrollView
    }()
    
    var wrapperView: UIView = {
        let wrapperView = UIView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        return wrapperView
    }()
    
    var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "logo")
        return logoImageView
    }()
    
    var bigFieldForTwoTextFieldsImageView: UIImageView = {
        let bigFieldForTwoTextFieldsImageView = UIImageView()
        bigFieldForTwoTextFieldsImageView.translatesAutoresizingMaskIntoConstraints = false
        bigFieldForTwoTextFieldsImageView.backgroundColor = .systemGray6
        bigFieldForTwoTextFieldsImageView.layer.cornerRadius = 10
        bigFieldForTwoTextFieldsImageView.layer.borderWidth = 0.5
        bigFieldForTwoTextFieldsImageView.layer.borderColor = UIColor.lightGray.cgColor
        return bigFieldForTwoTextFieldsImageView
    }()
    
    var emailOrPhoneTextField: UITextField = {
        let emailOrPhoneTextField = UITextField()
        emailOrPhoneTextField.translatesAutoresizingMaskIntoConstraints = false
        emailOrPhoneTextField.placeholder = "Email or Phone"
        return emailOrPhoneTextField
    }()
    
    var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        return passwordTextField
    }()
    
    let longLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    var logInButton: UIButton = {
        let logInButton = UIButton()
        logInButton.setTitle("Log In", for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.setTitleColor(.darkGray, for: .selected)
        logInButton.setTitleColor(.darkGray, for: .highlighted)
        logInButton.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel"), for: .normal)
        logInButton.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(0.8), for: .disabled)
        logInButton.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(0.8), for: .selected)
        logInButton.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(0.8), for: .highlighted)
        logInButton.layer.cornerRadius = 10
        logInButton.layer.masksToBounds = true
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.isUserInteractionEnabled = true
        logInButton.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        return logInButton
    }()
    
    var warning: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemRed
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //:- Загрузка данных контента
        tempStorage.tableModel = Storage.tableModel
        
        for (indexOfpostSection, postSection) in Storage.tableModel.enumerated() {
            
            if Storage.tableModel[indexOfpostSection].posts != nil {
                
                for (_, onePost) in postSection.posts!.enumerated(){
                    
                    tempUserContentArray.append((image: onePost.image, name: onePost.name, likes: onePost.likes, views: onePost.views, description: onePost.description))
                }
            }
        }
        
        setupViews()
    }
    
    func setupViews(){
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubview(logInScrollView)
        logInScrollView.addSubviews(wrapperView,
                                    logoImageView,
                                    bigFieldForTwoTextFieldsImageView,
                                    emailOrPhoneTextField,
                                    passwordTextField,
                                    longLine,
                                    logInButton,
                                    warning)
        
        let constraints = [
            logInScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logInScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            logInScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            logInScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            wrapperView.topAnchor.constraint(equalTo: logInScrollView.topAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: logInScrollView.bottomAnchor),
            wrapperView.leadingAnchor.constraint(equalTo: logInScrollView.leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: logInScrollView.trailingAnchor),
            wrapperView.widthAnchor.constraint(equalTo: logInScrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            bigFieldForTwoTextFieldsImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            bigFieldForTwoTextFieldsImageView.heightAnchor.constraint(equalToConstant: 100),
            bigFieldForTwoTextFieldsImageView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16),
            bigFieldForTwoTextFieldsImageView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16),
            
            emailOrPhoneTextField.topAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.topAnchor, constant: 16),
            emailOrPhoneTextField.leadingAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.leadingAnchor, constant: 16),
            emailOrPhoneTextField.trailingAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.trailingAnchor, constant: -16),
            
            passwordTextField.bottomAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.bottomAnchor, constant: -16),
            passwordTextField.leadingAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.trailingAnchor, constant: -16),
            
            longLine.topAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.centerYAnchor, constant: -0.25),
            longLine.leadingAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.leadingAnchor),
            longLine.trailingAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.trailingAnchor),
            longLine.bottomAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.centerYAnchor, constant: 0.25),
            
            logInButton.topAnchor.constraint(equalTo: bigFieldForTwoTextFieldsImageView.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            warning.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            warning.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func logInButtonPressed() {
        
        self.warning.textColor = .systemRed
        
        warning.text = ""
        
        guard let userDelegate = authorizationDelegate else {
            warning.text = "Authorization delegate is nil"
            return
        }
        
        guard let login = emailOrPhoneTextField.text,
              let password = passwordTextField.text else {
            warning.text = "Введите Логин и Пароль"
            return
        }
        
        guard let users = authorizationDelegate?.checkUsers() else {
            warning.text = "Incorrect data"
            return
        }
        
        func createNewUser(){
            
            let newUserID = UUID().uuidString
            
            if userDelegate.creteUser(id: newUserID, login: emailOrPhoneTextField.text, password: passwordTextField.text, failure: self.showAlert) {
                self.warning.textColor = .systemGreen
                self.warning.text = "Выполняется вход"
                print("Вход выполнен успешно")
                print ("Новый пользователь. Логин - \(String(describing: emailOrPhoneTextField.text!)). Пароль - \(String(describing: passwordTextField.text!))")
                
                //:- Фиксируем свойства Пользователя
                fixingUserProperties = userDelegate.loadUserProperties(id: newUserID)
                
                //:- Заполняем поля контента Нового Пользователя значениями по умолчанию
                fixingUserProperties?.currentUserStorage.tableModel = tempStorage.tableModel
                fixingUserProperties?.userContentArray = tempUserContentArray
                
                userDelegate.saveUserProperties(id: newUserID, userDataForSave: fixingUserProperties!)
                print("??? User Delegate Content = \(userDelegate.loadUserProperties(id: newUserID))")
                //                flowCoordinator!.profileCoordinatorAuthorizationDelegate!.saveUserProperties(id: flowCoordinator!.profileCoordinatorUserProperties!.id, userDataForSave: flowCoordinator!.profileCoordinatorUserProperties!)
                
                
                print("New User Properties = \(fixingUserProperties)")
                
                pushToMainProfileViewController()
                
            } else {
                warning.text = "Введите Логин и Пароль"
                return
            }
        }
        
        func showCreateAccounts(email: String, password: String){
            
            let alert = UIAlertController(title: "Создать Аккаунт",
                                          message: "Вы желаете создать аккаунт?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Продолжить",
                                          style: .default,
                                          handler: { _ in
                                            createNewUser()
                                            self.currentUserIndex = users.count
                                          }))
            alert.addAction(UIAlertAction(title: "Отмена",
                                          style: .cancel,
                                          handler: { _ in
                                          }))
            present(alert, animated: true)
        }
        
        if users.isEmpty{
            warning.text = "Необходимо авторизоваться"
            currentUserIndex = 0
            showCreateAccounts(email: login, password: password)
            
        }  else {
            
            // Выставляем флаг "Пользователь не найден"
            var userNotFound: Bool = true
            
            
            for (index, user) in users.enumerated() {
                
                if user.login == emailOrPhoneTextField.text && user.password == passwordTextField.text {
                    
                    //Если Пользователь с введенным Логином и Паролем найден, то
                    //Сохраняем значение текущего индекса Пользователя
                    currentUserIndex = index
                    
                    //Выставляем отрицательное значение флага "Пользователь не найден", поскольку Пользователь найден успешно
                    userNotFound = false
                    
                    warning.textColor = .systemGreen
                    warning.text = "Выполняется вход"
                    // Выводим в консоль информацию об активном Пользователе
                    print("Вход выполнен успешно")
                    print ("Действующий пользователь. Логин - \(user.login). Пароль - \(user.password)")
                    
                    //Фиксируем данные (переменные) текущего Пользователя
                    fixingUserProperties = users[index]
                    print("Действующие fixingUserProperties = \(fixingUserProperties)")
                    //Выполняем переход на экран MainProfileViewController()
                    pushToMainProfileViewController()
                    break
                    
                } else {
                    
                    if user.login != emailOrPhoneTextField.text {
                        userNotFound = true
                        
                    } else if user.password != passwordTextField.text {
                        userNotFound = false
                        print("Введеный Логин найден. Пароль введен некорректно. Для входа введите пароль")
                        print ("Найден пользователь с Логином. Логин - \(user.login). Пароль - \(user.password)")
                        warning.text = "Пароль введен неверно"
                        showAlert(error: .incorrectData)
                        return
                    }
                }
            }
            
            // Проходим циклом по всем Пользователям и сбрасываем флаг "Текущий Пользователь"
            for (index, _) in users.enumerated() {
                userDelegate.resetCurrentUser(id: users[index].id)
            }
            
            if userNotFound {
                warning.text = "Введите Логин и Пароль"
                print("User Not Found!")
                // show account creation
                // Если Пользователь с введенным Логином не найден, предлагаем создать Нового Пользователя
                showCreateAccounts(email: login, password: password)
                return
                //При успешном создании нового Пользователя активируем у него флаг "Текущий Пользователь" и запоминаем индекс
            } else {
                print("User Found!")
                // запоминаем индекс
                guard let currentIndex = currentUserIndex else  {
                    return
                }
                
                // Если Пользователь с введенным Логином успешно найден, фиксируем успешно вошедшего пользователя
                print ("Fixing current user: \(users[currentIndex].login)")
                print ("Current user Status: \(users[currentIndex].userStatus)")
                print ("Current user Status: \(users[currentIndex].currentUserStorage)")
                
                //запоминаем id
                let currentId = users[currentIndex].id
                
                // активируем у Пользователя флаг "Текущий Пользователь" и
                userDelegate.setCurrentUser(id: currentId)
            }
        }
    }
    
    func showAlert(error: Errors) {
        var message = ""
        switch error {
        case .incorrectData:
            message = "Введены неверные данные. Введите Пароль"
        case .shortPassword:
            message = "Пароль должен содержать минимум 6 символов"
        case .incorrectEmail:
            message = "Введены неверные данные. Введите Логин"
        case .noData:
            message = "Пожалуйста, введите Логин и Пароль"
        }
        
        let alertController = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("OK")
        }
        alertController.addAction(okAction)
        navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    func pushToMainProfileViewController(){
        
        flowCoordinator?.profileCoordinatorUserProperties = fixingUserProperties
        
        print("Передача переменных во flowCoordinator")
        print("flowCoordinator?.profileCoordinatorUserProperties")
        print(flowCoordinator?.profileCoordinatorUserProperties)
        
        guard let authorizationDelegate = authorizationDelegate else {
            return
        }
        flowCoordinator?.profileCoordinatorAuthorizationDelegate = authorizationDelegate
        
        // Go to MainProfileViewController
        flowCoordinator?.gotoProfile()
    }
    
    // MARK: - Keyboard observers
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        warning.text = "Введите Логин и Пароль"
        
        guard let allUsers = authorizationDelegate?.checkUsers() else {
            return
        }
        
        print("All users: \(String(describing: allUsers.self))")
        
        // Если список Пользователей не пустой
        if  !allUsers.isEmpty {
            // Проходим циклом по всем Пользователям
            for (index, user) in allUsers.enumerated() {
                
                // Если находим у какого Пользователя положительное значние isCurrentUser
                if user.isCurrentUser == true {
                    // сохраняем индекс данного Текущего Пользователя
                    currentUserIndex = index
                    // сохраняем значения полей Текущего Пользователя
                    
                    print("Current User: \(String(describing: allUsers[index]))")
                    print("Current User ID = \(String(describing: allUsers[index].id))")
                    print("Current User Status = \(String(describing: allUsers[index].userStatus))")
                    print("Current User Content = \(String(describing: allUsers[index].currentUserStorage))")
                    warning.textColor = .systemGreen
                    warning.text = "Выполняется вход"
                    
                    fixingUserProperties = allUsers[index]
                    pushToMainProfileViewController()
                    
                    break
                }
            }
            
        } else {
            
            warning.text = "Введите Логин и Пароль"
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        emailOrPhoneTextField.text = ""
        passwordTextField.text = ""
        warning.textColor = .systemRed
        warning.text = "Введите Логин и Пароль"
    }
    
    // MARK:- Keyboard actions
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            logInScrollView.contentInset.bottom = keyboardSize.height
            logInScrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        logInScrollView.contentInset.bottom = .zero
        logInScrollView.verticalScrollIndicatorInsets = .zero
    }
}


