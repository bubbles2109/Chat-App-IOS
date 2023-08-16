//
//  ChangePasswordController.swift
//  Project
//
//  Created by Phamcuong on 08/12/2022.
//

import UIKit
import FirebaseAuth

class ChangePasswordController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtReNewPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func tapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func tapOK(_ sender: Any) {
        Auth.auth().currentUser?.updatePassword(to: txtNewPassword.text!) { (error) in
          print("cập nhật thành công")
        
        }
    }
    
}
