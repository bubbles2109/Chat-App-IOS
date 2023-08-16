//
//  HomeController.swift
//  Project
//
//  Created by Phamcuong on 12/11/2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseCore

var visitor:User!

class ListFriendController: UIViewController {
    
    @IBOutlet weak var tblViewListFriend: UITableView!
    
    var listFriend: Array<User> = Array<User>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewListFriend.dataSource = self
        tblViewListFriend.delegate = self
        
        getDataListFriend()
    }
    
    func getDataListFriend(){
        let tableName = ref.child("Listfriend")
        tableName.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String: AnyObject]
            if postDict != nil {
                let email: String = (postDict?["email"]) as! String
                let fullName: String = (postDict?["fullName"]) as! String
                let linkAvatar: String = (postDict?["linkAvatar"]) as! String
                
                let user = User(id: snapshot.key, email: email, fullName: fullName, linkAvatar: linkAvatar)
                if (user.id != currentUser.id) {
                    self.listFriend.append(user)
                }
                print("---------------------\(self.listFriend)")
                self.tblViewListFriend.reloadData()
            }
        })
    }
    
}
extension ListFriendController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFriend.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListFriendTableViewCell
        cell.lbFullName.text = listFriend[indexPath.row].fullName
        cell.imgView.loadAvatar(link: listFriend[indexPath.row].linkAvatar)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatController {
            visitor = listFriend[indexPath.row]
            let url:URL = URL(string: visitor.linkAvatar)!
            do {
                let data:Data = try Data(contentsOf: url)
                visitor.avatar = UIImage(data: data)
            } catch {
                print("loiii")
            }
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
        }
    }
}
