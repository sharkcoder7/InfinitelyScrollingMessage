//
//  UIViewController + Alert.swift
//  MessagesApp
//
//  Created on denebtech 5/5/17.
//
//

import UIKit

typealias AlertActionHandler = (UIAlertAction)->()
typealias AlertPresentCompletion = ()->()

extension UIViewController{
    func presentErrorAlert(_ title:String? = nil, message:String, action:(AlertActionHandler)? = nil, completion:AlertPresentCompletion? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: action)
        alert.addAction(okAction)
        present(alert, animated: true, completion: completion)
    }
}
