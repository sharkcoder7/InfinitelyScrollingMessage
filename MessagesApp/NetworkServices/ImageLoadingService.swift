//
//  ImageLoadingService.swift
//  MessagesApp
//
//  Created on denebtech 5/5/17.
//
//

import UIKit

typealias PhotoLoaded = (MessageModel, UIImage)->()

class ImageLoadingService{
    fileprivate var messagesInProcess:Set<Int> = []
    
    func loadPhoto(_ message:MessageModel, onSuccess:@escaping PhotoLoaded, onFail:RequestError? = nil){
        guard !messagesInProcess.contains(message.messageId) else {return}
        guard let photoLink = message.messageAuthor.photoUrl,
        let url = URL(string: Endpoint.url(photoLink)) else {
            onFail?(nil)
            return
        }
        messagesInProcess.update(with: message.messageId)
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        let task = URLSession.shared.dataTask(with: request) {
            [weak self](data, response, requestError) in
            
            var image:UIImage?
            var error:Error?
            defer {
                DispatchQueue.main.async {
                    if let i = image {
                        onSuccess(message, i)
                    }
                    else{
                        onFail?(error)
                    }
                    self?.messagesInProcess.remove(message.messageId)
                }
            }
            
            guard let responseData = data,
                let img = UIImage(data: responseData) else{
                error = requestError
                return
            }
            image = img
        }
        task.resume()
    }
}
