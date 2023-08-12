//
//  SearchVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 05.08.23.
//

import UIKit

class SearchVC: UIViewController {
    
    var logoImageView = UIImageView()
    var textFieldView = GFTextField()
    var callToActionButton = GFButton(backgroundColor: UIColor.systemGreen, title: "Get Followers")
    
    var isUsernameEntered: Bool {
        return !textFieldView.text!.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        configureImage()
        configureTextField()
        configureOnTapAction()
        
        dismissKeyboardWithTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        textFieldView.text = ""
    }
    
    @objc func pushFollowersListVC() {
        
        guard isUsernameEntered else {
            presentGFAlert(title: "No Username", message: "Please enter a username.", buttonTitle: "Ok")
            return
        }
        
        let followersVC = FollowersListVC()
        followersVC.username = textFieldView.text
        followersVC.title = textFieldView.text
        
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    private func configureImage() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
    }
    
    private func configureTextField() {
        view.addSubview(textFieldView)
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldView.delegate = self
    
        NSLayoutConstraint.activate([
            textFieldView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            textFieldView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureOnTapAction() {
        view.addSubview(callToActionButton)
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        
        callToActionButton.addTarget(self, action: #selector(pushFollowersListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func dismissKeyboardWithTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersListVC()
        return true
    }
}
