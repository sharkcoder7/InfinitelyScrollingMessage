//
//  ShadowView.swift
//  MessagesApp
//
//  Created on denebtech 5/5/17.
//
//

import UIKit

@IBDesignable
class ShadowView: UIView {

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
    
    
    //MARK: --
    //MARK: Shadow
    @IBInspectable var shadowColor:UIColor{
        get{
            guard let color = layer.shadowColor else{
                return UIColor.clear
            }
            return UIColor(cgColor: color)
        }
        set{
            layer.shadowColor = newValue.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOpacity:CGFloat{
        get{
            return CGFloat(layer.shadowOpacity)
        }
        set{
            layer.shadowOpacity = Float(newValue)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOffset:CGSize{
        get{
            return layer.shadowOffset
        }
        set{
            layer.shadowOffset = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowRadius:CGFloat{
        get{
            return layer.shadowRadius
        }
        set{
            layer.shadowRadius = newValue
            setNeedsDisplay()
        }
    }

}
