//
//  MessagesVC.swift
//  Messages App
//
//  Created on denebtech 5/5/17.
//
//

import UIKit

class MessagesVC: UITableViewController, MessageCellDelegate {

    fileprivate let messageCellIdent = "MessageCell"
    
    fileprivate var messagePages = [PageModel]()
    
    fileprivate let messageNetworkService = MessageNetworkService()
    fileprivate let imageLoadingService = ImageLoadingService()
    
    
    //MARK: --
    //MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        loadMessagePage()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return messagePages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let page = messagePages[section]
        return page.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellIdent) as! MessageCell
        
        let page = messagePages[indexPath.section]
        let message = page.messages[indexPath.row]
        
        cell.delegate = self
        
        cell.lblName.text = message.messageAuthor.name
        cell.lblDate.text = message.messageUpdateDate.timeAgo() ?? ""
        cell.lblContent.text = message.messageContent
        cell.imgPhoto.image = nil
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let page = messagePages[indexPath.section]
        let message = page.messages[indexPath.row]
        updatePhoto(message)
        
        guard indexPath.section == messagePages.count-1 else {return}
        loadMessagePage(page.nextPageToken)
    }
    
    //MARK: --
    //MARK: MessageCellDelegate
    func messageCellSwipeDidBegin(_ cell: MessageCell) {
        tableView.isScrollEnabled = false
    }
    
    func messageCellSwipeDidCancel(_ cell: MessageCell) {
        tableView.isScrollEnabled = true
    }
    
    func messageCellSwipeDeleteAction(_ cell: MessageCell, direction: CellDeleteDirection) {
		defer {
			self.tableView.isScrollEnabled = true
		}
		guard let indexPath = self.tableView.indexPath(for: cell) else{
			return
		}
		let page = self.messagePages[indexPath.section]
		self.tableView.beginUpdates()
		page.messages.remove(at: indexPath.row)
		self.tableView.deleteRows(at: [indexPath], with: direction == .left ? .left : .right)
		self.tableView.endUpdates()
/*
		// Show alertview, if ok, delete...if cancel, keep message.
		let alert = UIAlertController(title: "Alert", message: "Do you want to delete message.", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
			defer {
				self.tableView.isScrollEnabled = true
			}
			guard let indexPath = self.tableView.indexPath(for: cell) else{
				return
			}
			let page = self.messagePages[indexPath.section]
			self.tableView.beginUpdates()
			page.messages.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: direction == .left ? .left : .right)
			self.tableView.endUpdates()
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
			self.tableView.isScrollEnabled = true
			self.tableView.reloadData()
		}))
		self.present(alert, animated: true, completion: nil)
*/
	}
    
    //MARK: --
    //MARK: Instance methods
    fileprivate func loadMessagePage(_ pageToken:String? = nil){
        messageNetworkService.loadMessagesPage(pageToken, onSuccess: {
            [weak self](page) in
            guard let pages = self?.messagePages,
            !pages.contains(page) else{return}

            guard let token = pageToken,
                let previousPageIndex = self?.messagePages.index(where: {$0.nextPageToken == token})else{
                self?.messagePages.append(page)
                self?.tableView.reloadData()
                return
            }
            
            let pageIndex = previousPageIndex+1
            self?.messagePages.insert(page, at: pageIndex)
            self?.tableView.reloadData()
            
        }) { [weak self](error) in
            let errorMessage = error?.localizedDescription
            guard errorMessage == nil else{
                self?.presentErrorAlert(message: errorMessage!)
                return
            }
            if let isEmpty = self?.messagePages.isEmpty, isEmpty {
                return
            }
            self?.presentErrorAlert(message: "Something went wrong.\nCan't load messages.")
        }
    }
    
    fileprivate func configureViews(){
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    fileprivate func updatePhoto(_ message:MessageModel){
        imageLoadingService.loadPhoto(message, onSuccess: {
            [weak self](model, image) in
            guard let page = model.page,
                let pageIndex = self?.messagePages.index(of: page),
                let messageIndex = page.messages.index(of: model) else{
                    return
            }
            let indexPath = IndexPath(row: messageIndex, section: pageIndex)
            guard let cell = self?.tableView.cellForRow(at: indexPath) as? MessageCell else{
                return
            }
            cell.imgPhoto.image = image
        })
    }
}
