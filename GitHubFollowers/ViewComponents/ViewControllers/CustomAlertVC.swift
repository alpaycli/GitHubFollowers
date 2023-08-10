//
//  CustomAlertVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 06.08.23.
//

import UIKit

class CustomAlertVC: UIViewController {

    var containerView = UIView()
    
    var titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    var messageLabel = GFBodyLabel(textAlignment: .center)
    var callToActionButton = GFButton(backgroundColor: .systemPink, title: "Ok")
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20
    
    init(alertTitle: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configureContainerView()
        configureTitleLabel()
        configureButton()
        configureMessageLabel()
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.layer.cornerRadius = 16
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.backgroundColor = .systemBackground
        containerView.layer.borderWidth = 2
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? ""
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func configureButton() {
        containerView.addSubview(callToActionButton)
        callToActionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        
        callToActionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            callToActionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            callToActionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            callToActionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? "Something went wrong"
        messageLabel.numberOfLines = 4
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: callToActionButton.topAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
