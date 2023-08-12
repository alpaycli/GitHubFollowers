//
//  GFRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 12.08.23.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {

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
