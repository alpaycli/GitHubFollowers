//
//  UIViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 06.08.23.
//

import SafariServices
import UIKit

fileprivate var containerView: UIView!

extension UIViewController {
    
    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alert = CustomAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            
            self.present(alert, animated: true)
        }
    }
    
    func presentSafariVC(with url: URL) {
        let safariView = SFSafariViewController(url: url)
        safariView.preferredControlTintColor = .systemGreen
        present(safariView, animated: true)
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        activityIndicator.startAnimating()
        
        print("Loading...")
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
        print("Hiding...")
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmtpyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
}
