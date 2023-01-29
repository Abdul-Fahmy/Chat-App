//
//  MessageVC.swift
//  Chat-Bee
//
//  Created by mac on 08/01/2023.
//

import UIKit

class MessageVC: UIViewController {
    
    //Mark:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var msgBodyTF: UITextField!
    
    
    @IBOutlet weak var senderBtnOutlet: UIButton!
    
    
    
    
    //Mark:- Constants
    
    var ChatRoomId: String!
    var usersId: [String]!
    var messages = [Messages]()
    var users = [FUser]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        
        
        messages = []
        
        ChatRoomId = getChatRoomId(fUserId: usersId.first!, sUserId: usersId.last!)
        
        
        getMessages()
        
    }
    
    //Mark:- IBAction
    
    
    
    @IBAction func senderBtnPressed(_ sender: Any) {
        if msgBodyTF.text != "" {
       
                   senderBtnOutlet.isEnabled = false
                   sendMyMessage(text: msgBodyTF.text!)
               }
    }
    
    
    
    //Mark:- Helper Function
    
    func sendMyMessage(text:String?){
        
        if let text = text {
            let MessageId = UUID().uuidString
            
            let goingMessage = OutgoingMessages(message: text, senderId: FUser.currentId(), senderName: FUser.currentUser()?.fullname ?? "", date: Date(), messageType: kPRIVATE, type: messageType(.text), messageId: MessageId)
            
//            OutgoingMessages(message: text, senderId: FUser.currentId(), senderName: FUser.currentUser()?.fullname ?? "", date: Date(), messageType: kPRIVATE, type: messageType(.text), messageId: MessageId)
            
            goingMessage.sendMessage(chatRoomId: ChatRoomId, messageDictionary: goingMessage.messagesDictionary, membersIds: usersId)
//            goingMessage.sendMessage(chatRoomId: ChatRoomId, messageDictionary: goingMessage.messagesDictionary, membersIds: usersId)
            
            msgBodyTF.text = ""
            senderBtnOutlet.isEnabled = true
        }
        
    }
    
    func getMessages(){
        DBref.child(reference(.Message)).child(FUser.currentId()).child(ChatRoomId).queryOrdered(byChild: kDATE).observe(.childAdded) {(snapshot) in
            
            
            let snap = snapshot.value as! NSDictionary
            
            let newMessage = Messages(_dictionary: snap)
            
            self.messages.append(newMessage)
            
            self.tableView.reloadData()
            self.scrollDown()
        
        }
        
    }
    
    func scrollDown(){
        DispatchQueue.main.async {
            let indexpath = IndexPath(row: self.messages.count - 1 , section: 0)
            if (indexpath.row > 0)  {
                self.tableView.scrollToRow(at: indexpath, at: UITableView.ScrollPosition.bottom, animated: false)
                
            }
        }
    }
    

}
extension MessageVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].senderId == FUser.currentId(){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! MyMessageTVCell
            
            cell.messageLBL.text = messages[indexPath.row].message
            cell.dateLBL.text = timeElapsed(date: messages[indexPath.row].date)
            
//            cell.messageLBL.text = messages[indexPath.row].message
//            cell.dateLBL.text = timeElapsed(date: messages[indexPath.row].date)
            
            
            
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! MyFriendsMessageTVCell
            cell.messageLBL.text = messages[indexPath.row].message
            cell.dateLBL.text = timeElapsed(date: messages[indexPath.row].date)
//            cell.messageLBL.text = messages[indexPath.row].message
//            cell.dateLBL.text = timeElapsed(date: messages[indexPath.row].date)
            
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
   
    
    
}
