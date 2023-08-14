//
//  GFAlertContainerView.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 14.08.23.
//

import UIKit

class GFAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius = 16
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = .systemBackground
        layer.borderWidth = 2
        translatesAutoresizingMaskIntoConstraints = false
    }
}
