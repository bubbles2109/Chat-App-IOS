//
//  ProfileController.swift
//  Project
//
//  Created by Phamcuong on 22/11/2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfileController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    func updateUI() {
        let user = Auth.auth().currentUser
        if let user = user {
            lbName.text = user.displayName
        } else {
            print("khong co user")
        }
    }
    
    @IBAction func tapLogOut(_ sender: Any) {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tabLogin")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func tapChangePassword(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordController
        navigationController?.pushViewController(vc, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
}
