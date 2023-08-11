//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 10.08.23.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var headerView = UIView()
    var infoViewOne = UIView()
    var infoViewTwo = UIView()
    
    var itemViews: [UIView] = []

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        layoutUI()
        fetchUser()
    }
    
    private func fetchUser() {
        UserFetcher.shared.getUser(for: username) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        itemViews = [headerView, infoViewOne, infoViewTwo]
        
        itemViews.forEach { item in
            view.addSubview(item)
            
            item.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                item.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
        infoViewOne.backgroundColor = .systemRed
        infoViewTwo.backgroundColor = .systemBlue
                
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            infoViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            infoViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            infoViewTwo.topAnchor.constraint(equalTo: infoViewOne.bottomAnchor, constant: padding),
            infoViewTwo.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func setupViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
