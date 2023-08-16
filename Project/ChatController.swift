//
//  ChatController.swift
//  Project
//
//  Created by Phamcuong on 16/11/2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseCore

class ChatController: UIViewController {
    
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var tblViewChat: UITableView!
    
    var tableName:DatabaseReference!
    var arrIdChat:Array<String> = Array<String>()
    var arrtxtChat:Array<String> = Array<String>()
    var arrUserChat:Array<User> = Array<User>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewChat.delegate = self
        tblViewChat.dataSource = self
        
        arrIdChat.append(currentUser.id)
        arrIdChat.append(visitor.id)
        arrIdChat.sort()
        let key:String = "\(arrIdChat[0])\(arrIdChat[1])"
        tableName = ref.child("Chat").child(key)
        
        tableName.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            if postDict != nil {
                if postDict?["id"] as! String == currentUser.id {
                    self.arrUserChat.append(currentUser)
                } else {
                    self.arrUserChat.append(visitor)
                }
                self.arrtxtChat.append(postDict?["message"] as! String)
                self.tblViewChat.reloadData()
            }
        })
    }
    @IBAction func tapBack(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    @IBAction func tapSendMessage(_ sender: Any) {
        let mess: Dictionary<String,String> = ["id": currentUser.id, "message": tfMessage.text!]
        tableName.childByAutoId().setValue(mess)
        tfMessage.text! = ""
        if (arrtxtChat.count == 0) {
            addListChat(user1: currentUser, user2: visitor)
            addListChat(user1: visitor, user2: currentUser)
        }
    }
    
    func addListChat(user1: User, user2: User) {
        let tblChat = ref.child("ListChat").child(user1.id).child(user2.id)
        let user:Dictionary<String,String> = ["id": user2.id, "email": user2.email, "fullName": user2.fullName, "linkAvatar": user2.linkAvatar]
        tblChat.setValue(user)
    }
}

extension ChatController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrtxtChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (currentUser.id == arrUserChat[indexPath.row].id) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyChatTableViewCell
            cell.lbMessage.text = arrtxtChat[indexPath.row]
            cell.imgAvatar.image = currentUser.avatar
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendChatTableViewCell
            cell.lbMessage.text = arrtxtChat[indexPath.row]
            cell.imgAvatar.image = visitor.avatar
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
