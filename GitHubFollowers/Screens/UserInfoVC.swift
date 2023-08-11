//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 10.08.23.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var headerView = UIView()

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        layoutUI()
        
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
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
