//
//  UIViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 06.08.23.
//

import SafariServices
import UIKit

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
    
}
