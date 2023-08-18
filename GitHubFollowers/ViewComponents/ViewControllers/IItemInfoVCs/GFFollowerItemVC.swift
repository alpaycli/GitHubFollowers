//
//  GFFollowerItemVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 12.08.23.
//

import UIKit

protocol GFFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {
    
    weak var delegate: GFFollowerItemVCDelegate!
    
    init(user: User, delegate: GFFollowerItemVCDelegate!) {
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
        itemViewTwo.set(itemType: .followers, withCount: user.followers)
        itemViewOne.set(itemType: .following, withCount: user.following)
        buttonLabel.set(backgroundColor: .systemBlue, title: "Get Followers")
    }
    
    override func onTapAction() {
        delegate.didTapGetFollowers(for: user)
    }
}
