//
//  AuthorModel.swift
//  Messages App
//
//  Created on denebtech 5/5/17.
//
//

import Foundation
import SwiftyJSON

class AuthorModel{
    let name:String
    fileprivate(set) var photoUrl:String?
    
    required init?(_ json:JSON) {
        guard let name = json[AuthorKey.name].string else {
            return nil
        }
        self.name = name
        photoUrl = json[AuthorKey.photoURL].string
    }
}

fileprivate struct AuthorKey{
    static let name = "name"
    static let photoURL = "photoUrl"
}
