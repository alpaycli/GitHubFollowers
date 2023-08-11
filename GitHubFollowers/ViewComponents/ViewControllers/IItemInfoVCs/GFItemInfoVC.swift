//
//  GFItemInfoVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 12.08.23.
//

import UIKit

class GFItemInfoVC: UIViewController {
    
    var stackView = UIStackView()
    var itemViewOne = GFItemInfoView()
    var itemViewTwo = GFItemInfoView()
    var buttonLabel = GFButton()
    
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureStackView()
        layoutUI()
    }
    
    private func setupView() {
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(itemViewOne)
        stackView.addArrangedSubview(itemViewTwo)
    }

    private func layoutUI() {
        view.addSubview(stackView)
        view.addSubview(buttonLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            buttonLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            buttonLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            buttonLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            buttonLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
