//
//  FavoriteCell.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 13.08.23.
//

import UIKit

class FavoriteCell: UITableViewCell {

    static let reuseId = "FavoriteCell"
    let avatarImage = GFAvatarImageView(frame: .zero)
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(favorite: Follower) {
        titleLabel.text = favorite.login
        NetworkManager.shared.downloadImage(urlString: favorite.avatarUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.avatarImage.image = image
            }
        }
    }
    
    private func configure() {
        addSubview(avatarImage)
        addSubview(titleLabel)
        
        let padding: CGFloat = 12
        
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            avatarImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImage.widthAnchor.constraint(equalToConstant: 60),
            avatarImage.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: padding * 2),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }

    
}
