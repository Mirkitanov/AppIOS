//
//  MainProfileViewController.swift
//  Navigation
//
//  Created by Админ on 16.02.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class MainProfileViewController: UIViewController {
    
    weak var flowCoordinator: ProfileCoordinator?
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    var profileUserContentArray : [(image: String, name: String, likes: String, views: String, description: String?)] = []
    var postSimple: Post?
    var postSimpleArray: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //:- Формирование контента для загрузки
        
        for (indexOfpostSection, postSection) in Storage.tableModel.enumerated() {
            
            if Storage.tableModel[indexOfpostSection].posts != nil {
                
                for (indexOfPost, onePost) in postSection.posts!.enumerated(){
                    profileUserContentArray.append((image: onePost.image, name: onePost.name, likes: onePost.likes, views: onePost.views, description: onePost.description))
                }
            }
        }
        
        ///////////////////
        for (index, element) in profileUserContentArray.enumerated() {
            print("UserContentArray[\(index)] = \(element)")
            
            postSimple = Post(image: element.image, name: element.name, likes: element.likes, views: element.views, description: element.description)
            
            print("postSimple = \(postSimple)")
            
            guard let postToAppend = postSimple else {
                break
            }
            print("postToAppend = \(postToAppend)")
            
            postSimpleArray.append(postToAppend)
            print("postSimpleArray = \(postSimpleArray)")
            print("postSimpleArray.count = \(postSimpleArray.count)")
            
        }
        
        setupTableView()
        setupViews()
        setupMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: String(describing: PhotosTableViewCell.self))
    }
    
    private func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //:- Настройка Меню
    private func setupMenu() {
        
        let changeUserForAnother = UIAction(title: "Войти другим Пользователем", image: UIImage(systemName: "person.and.arrow.left.and.arrow.right")) { [unowned self] (action) in
            
            if let id = flowCoordinator?.profileCoordinatorUserProperties?.id {
                print("id!!!!")
                print(id)
                print("flowCoordinator?.profileCoordinatorUserProperties = \(flowCoordinator?.profileCoordinatorUserProperties)")
                flowCoordinator?.profileCoordinatorAuthorizationDelegate?.resetCurrentUser(id: id)
                flowCoordinator?.backtoRoot()
            }
        }
        
        let changeCurrentUserName = UIAction(title: "Изменить имя текущего Пользователя", image: UIImage(systemName: "smiley")) { [unowned self ] (action) in
            flowCoordinator?.gotoChangeUserName()
        }
        
        //:- Установка меню в NavigationBar
        let menu = UIMenu(title: "ОСНОВНОЕ МЕНЮ",
                          options: .displayInline,
                          children: [changeUserForAnother,
                                     changeCurrentUserName])
        
        let infoBarItem: UIBarButtonItem = UIBarButtonItem(title: "Меню", menu: menu)
        
        
        self.navigationItem.rightBarButtonItem = infoBarItem
    }
}

extension MainProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        switch section {
        case 0:
            return 1
        default:
            return profileUserContentArray.count
        }
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        switch indexPath.section {
        case 0:
            print ("PHOTOS!!!")
            let cell: PhotosTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotosTableViewCell.self), for: indexPath) as! PhotosTableViewCell
            return cell
        default:
            print ("POSTS!!!")
            let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
            cell.postInScreen = postSimpleArray[indexPath.row]
            return cell
        }
    }
}

extension MainProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return .zero }
        
        return 220
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = flowCoordinator?.profileCoordinatorHeaderView
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            flowCoordinator?.gotoPhotos()
        default:
            return
        }
    }
}


