//
//  ImageView.swift
//  MessagesApp
//
//  Created on denebtech 5/5/17.
//
//

import UIKit

@IBDesignable
class ImageView: UIImageView {

    //MARK: --
    //MARK: Corner
    @IBInspectable var cornerRadius:CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            setNeedsDisplay()
        }
    }

}
