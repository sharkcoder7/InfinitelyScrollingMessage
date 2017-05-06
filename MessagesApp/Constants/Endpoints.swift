//
//  Endpoints.swift
//  MessagesApp
//
//  Created on denebtech 5/5/17.
//
//

import Foundation

enum Endpoint:String {
    static func url(_ endpoint:Endpoint)->String{
        return "https://message-list.appspot.com/"+endpoint.rawValue
    }
    
    static func url(_ endpoint:String)->String{
        return "https://message-list.appspot.com/"+endpoint
    }
    
    case messages = "messages"
}
