//
//  UIView+Ext.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 18.08.23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
