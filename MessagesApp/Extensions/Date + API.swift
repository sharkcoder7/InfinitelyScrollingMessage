//
//  Date + API.swift
//  MessagesApp
//
//  Created on denebtech 5/5/17.
//
//

import Foundation

extension Date{
    static func date(_ apiString:String)->Date?{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter.date(from:apiString)
    }
}
