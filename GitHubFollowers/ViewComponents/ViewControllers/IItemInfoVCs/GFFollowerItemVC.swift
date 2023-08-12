//
//  GFFollowerItemVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 12.08.23.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        itemViewTwo.set(itemType: .followers, withCount: user.followers)
        itemViewOne.set(itemType: .following, withCount: user.following)
        buttonLabel.set(backgroundColor: .systemBlue, title: "Get Followers")
    }
    
    override func onTapAction() {
        delegate.didTapGetFollowers(for: user)
    }
}
