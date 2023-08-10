//
//  FollowerCell.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 08.08.23.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    
    static let reuseId = "FollowerCell"
    
    let imageView = GFAvatarImageView(frame: .zero)
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageAndTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower) {
        titleLabel.text = follower.login
        imageView.downloadImage(urlString: follower.avatarUrl)
    }
    
    
    private func configureImageAndTitle() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        let padding: CGFloat = 8
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
