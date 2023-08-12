//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 12.08.23.
//

import Foundation

extension Date {
    
    func convertDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.string(from: self)
    }
    
}
