//
//  MessageNetworkService.swift
//  MessagesApp
//
//  Created on denebtech 5/5/17.
//
//

import Foundation
import SwiftyJSON

typealias PageLoaded = (PageModel)->()
typealias RequestError = (Error?)->()

class MessageNetworkService{
    fileprivate var pagesInProcess:Set<String> = []
    
    func loadMessagesPage(_ pageToken:String? = nil, messageLimit:Int = 20, onSuccess:@escaping PageLoaded, onFail:RequestError? = nil){
        guard !pagesInProcess.contains(pageToken ?? "_") else {return}
        var urlString = Endpoint.url(.messages)+"?limit=\(messageLimit)"
        if let token = pageToken{
            urlString += "&pageToken=\(token)"
        }
        guard let url = URL(string: urlString) else{
            onFail?(nil)
            return
        }
        pagesInProcess.update(with: pageToken ?? "_")
        let task = URLSession.shared.dataTask(with: url) {
            [weak self](data, response, requestError) in
            
            var messagesPage:PageModel?
            var error:Error?
            defer {
                DispatchQueue.main.async {
                    if let page = messagesPage {
                        onSuccess(page)
                    }
                    else{
                        onFail?(error)
                    }
                    self?.pagesInProcess.remove(pageToken ?? "_")
                }
            }
            
            guard let responseData = data else{
                error = requestError
                return
            }
            let json = JSON(data:responseData)
            guard let page = PageModel(json) else{
                return
            }
            messagesPage = page
        }
        task.resume()
    }
}
