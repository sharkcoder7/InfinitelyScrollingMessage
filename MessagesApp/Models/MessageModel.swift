//
//  MessageModel.swift
//  Messages App
//
//  Created on denebtech 5/5/17.
//
//

import Foundation
import SwiftyJSON

class MessageModel:Hashable{
    fileprivate(set) weak var page:PageModel!
    fileprivate(set) var messageId:Int!
    fileprivate(set) var messageUpdateDate:Date!
    fileprivate(set) var messageContent:String!
    fileprivate(set) var messageAuthor:AuthorModel!
    
    let messageType:MessageType
    
    required init(_ json:JSON, page:PageModel) {
        guard let id = json[MessageKey.id].int,
            let updatedString = json[MessageKey.updated].string,
            let updated = Date.date(updatedString),
            let content = json[MessageKey.content].string,
            let author = AuthorModel(json[MessageKey.author]) else {
                messageType = .broken
                return
        }
        self.page = page
        messageId = id
        messageUpdateDate = updated
        messageAuthor = author
        messageContent = content
        messageType = .normal
    }
    
    //MARK: --
    //MARK: Hashable
    var hashValue: Int{
        get{
            return messageId
        }
    }
    
    static public func ==(left:MessageModel, right:MessageModel)->Bool{
        return left.messageId == right.messageId
    }
    
}


enum MessageType{
    case normal, broken
}

fileprivate struct MessageKey{
    static let id = "id"
    static let author = "author"
    static let updated = "updated"
    static let content = "content"
}
