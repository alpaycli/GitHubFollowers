//
//  GFRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 12.08.23.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate: GFRepoItemVCDelegate!
    
    init(user: User, delegate: GFRepoItemVCDelegate!) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        itemViewTwo.set(itemType: .repos, withCount: user.publicRepos)
        itemViewOne.set(itemType: .gists, withCount: user.publicGists)
        buttonLabel.set(backgroundColor: .systemPurple, title: "Go to GitHub")
    }
    
    override func onTapAction() {
        delegate.didTapGitHubProfile(for: user)
    }

}
