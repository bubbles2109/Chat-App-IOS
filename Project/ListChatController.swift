//
//  ListChatController.swift
//  Project
//
//  Created by Phamcuong on 14/11/2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseCore

let ref = Database.database().reference()

var currentUser:User!

class ListChatController: UIViewController {
    
    @IBOutlet weak var tblListChat: UITableView!
    
    var arrUserChat: Array<User> = Array<User>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblListChat.dataSource = self
        tblListChat.delegate = self
        
        getProfile()
        addListChat()
    }
    
    func getProfile() {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let fullName = user.displayName
            let email = user.email
            let photoURL = user.photoURL
            let nn = photoURL?.absoluteString
            currentUser = User(id: uid, email: email!, fullName: fullName!, linkAvatar: nn!)
            let tableName = ref.child("Listfriend")
            let userId = tableName.child(currentUser.id)
            let user: Dictionary<String,String> = ["email": currentUser.email, "fullName": currentUser.fullName, "linkAvatar": currentUser.linkAvatar]
            userId.setValue(user)
            let url:URL = URL(string: currentUser.linkAvatar)!
            do {
                let data:Data = try Data(contentsOf: url)
                currentUser.avatar = UIImage(data: data)
            } catch {
                print("Download anh khong thanh cong")
            }
        } else {
            print("khong co user")
        }
    }
    
    func addListChat() {
        let tableName = ref.child("ListChat").child(currentUser.id)
        tableName.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String: AnyObject]
            if postDict != nil {
                let email: String = (postDict?["email"]) as! String
                let fullName: String = (postDict?["fullName"]) as! String
                let linkAvatar: String = (postDict?["linkAvatar"]) as! String
                
                let user = User(id: snapshot.key, email: email, fullName: fullName, linkAvatar: linkAvatar)
                self.arrUserChat.append(user)
                self.tblListChat.reloadData()
            }
        })
    }

}

extension ListChatController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListChatTableViewCell
        cell.lbFullName.text = arrUserChat[indexPath.row].fullName
        cell.imgView.loadAvatar(link: arrUserChat[indexPath.row].linkAvatar)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatController {
            visitor = arrUserChat[indexPath.row]
            let url:URL = URL(string: visitor.linkAvatar)!
            do {
                let data:Data = try Data(contentsOf: url)
                visitor.avatar = UIImage(data: data)
            } catch {
                print("loi")
            }
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
}
