//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 10.08.23.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didTapGetFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
    
    private let headerView = UIView()
    private let infoViewOne = UIView()
    private let infoViewTwo = UIView()
    private let dateLabel = GFBodyLabel(textAlignment: .center)
    
    private var itemViews: [UIView] = []

    var username: String!
    weak var delegate: UserInfoVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        layoutUI()
        fetchUser()
    }
    
    private func fetchUser() {
        showLoadingView()
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            
            self.hideLoadingView()
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.configureUIElements(for: user)
                    
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
    
    private func configureUIElements(for user: User) {
        let repoItemVC = GFRepoItemVC(user: user, delegate: self)
        let followerItemVC = GFFollowerItemVC(user: user, delegate: self)
        
        self.add(childVC: repoItemVC, to: self.infoViewOne)
        self.add(childVC: followerItemVC, to: self.infoViewTwo)
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertDateToString())"
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        itemViews = [headerView, infoViewOne, infoViewTwo, dateLabel]
        
        itemViews.forEach { item in
            view.addSubview(item)
            
            item.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                item.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
                
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            infoViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            infoViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            infoViewTwo.topAnchor.constraint(equalTo: infoViewOne.bottomAnchor, constant: padding),
            infoViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
            dateLabel.topAnchor.constraint(equalTo: infoViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
            
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

extension UserInfoVC: GFRepoItemVCDelegate {
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlert(title: "Something went wrong.", message: "User's profile missing or check your internet connection.", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
}

extension UserInfoVC: GFFollowerItemVCDelegate {
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlert(title: "No Follower", message: "This user has no follower.", buttonTitle: "Ha-ha")
            return
        }
        dismissVC()
        delegate.didTapGetFollowers(for: user.login)
    }

}
