//
//  MessageCell.swift
//  MessagesApp
//
//  Created on denebtech 5/5/17.
//
//

import UIKit

protocol MessageCellDelegate:class {
    func messageCellSwipeDidBegin(_ cell:MessageCell)
    func messageCellSwipeDidCancel(_ cell:MessageCell)
    func messageCellSwipeDeleteAction(_ cell:MessageCell, direction:CellDeleteDirection)
}

enum CellDeleteDirection{
    case left, right
}

class MessageCell: UITableViewCell {
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var bkgView: UIView!

    weak var delegate:MessageCellDelegate?
    
    fileprivate var panGesture:UIPanGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureAction(_:)))
        panGesture?.maximumNumberOfTouches = 1
        panGesture?.delegate = self
        bkgView.addGestureRecognizer(panGesture!)
    }
    
    override func prepareForReuse() {
        bkgView.transform = CGAffineTransform.identity
        bkgView.alpha = 1
    }
    
    //MARK: --
    //MARK: Gesture action
    func panGestureAction(_ sender:UIPanGestureRecognizer){
        let velocity = sender.velocity(in: sender.view)
        switch sender.state {
        case .began:
            guard fabs(velocity.x) > fabs(velocity.y*1.5) else {
                sender.isEnabled = false
                sender.isEnabled = true
                return
            }
            delegate?.messageCellSwipeDidBegin(self)
            break
        case .changed:
            let translation = sender.translation(in: sender.view)
            let transform = CGAffineTransform(translationX: translation.x, y: 0)
            bkgView.transform = transform
            let newAlpha = 1 - fabs(translation.x)/bkgView.frame.size.width
            bkgView.alpha = newAlpha
            break
        case .ended:
            let translation = sender.translation(in: sender.view)
            guard fabs(translation.x) <= bkgView.frame.size.width/2 else{
                delegate?.messageCellSwipeDeleteAction(self, direction: translation.x < 0 ? .left : .right)
                return
            }
            UIView.animate(withDuration: 0.15, animations: {
                [weak self] in
                self?.bkgView.transform = CGAffineTransform.identity
                self?.bkgView.alpha = 1
                }, completion: {(_) in
                    self.delegate?.messageCellSwipeDidCancel(self)
            })
            break
        default:
            delegate?.messageCellSwipeDidCancel(self)
            bkgView.alpha = 1
            break
        }
    }

    //MARK: --
    //MARK: UITableViewCell
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == panGesture else {
            return false
        }
        return true
    }
    
}
