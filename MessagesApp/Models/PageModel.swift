//
//  PageModel.swift
//  Messages App
//
//  Created on denebtech 5/5/17.
//
//

import Foundation
import SwiftyJSON

class PageModel:Hashable{
    var messages:[MessageModel] = []
    var nextPageToken:String
    
    init?(_ json:JSON) {
        guard let pageToken = json[PageKey.pageToken].string,
            let pageMessages = json[PageKey.messages].array else {
                return nil
        }
        nextPageToken = pageToken
        messages = pageMessages
            .map({ (json) -> MessageModel in
            return MessageModel(json, page: self)
        })
            .filter({$0.messageType == .normal})
            .sorted(by: {$0.messageUpdateDate > $1.messageUpdateDate})
    }
    
    //MARK: --
    //MARK: Hashable
    var hashValue: Int{
        get{
            return nextPageToken.hashValue
        }
    }
    
    static public func ==(left:PageModel, right:PageModel)->Bool{
        return left.nextPageToken == right.nextPageToken
    }
}


fileprivate struct PageKey{
    static let pageToken = "pageToken"
    static let messages = "messages"
}
