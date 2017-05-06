//
//  Date + Formatter.swift
//  MessagesApp
//
//  Created on denebtech 5/5/17.
//
//

import Foundation

extension Date{
    func timeAgo() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.era, .year, .month, .weekOfMonth, .day, .hour, .minute, .second], from: self, to: Date())
        
        if components.year! > 0 {
            formatter.allowedUnits = .year
        } else if components.month! > 0 {
            formatter.allowedUnits = .month
        } else if components.weekOfMonth! > 0 {
            formatter.allowedUnits = .weekOfMonth
        } else if components.day! > 0 {
            formatter.allowedUnits = .day
        } else if components.hour! > 0 {
            formatter.allowedUnits = .hour
        } else if components.minute! > 0 {
            formatter.allowedUnits = .minute
        } else {
            formatter.allowedUnits = .second
        }
        
        let formatString = "%@ ago"
        guard let timeString = formatter.string(from: components) else {
            return nil
        }
        return String(format: formatString, timeString)
    }
}
