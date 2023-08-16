//
//  ForgotPasswordController.swift
//  Project
//
//  Created by Phamcuong on 29/11/2022.
//

import UIKit
import FirebaseAuth

class ForgotPasswordController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnOK: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func tapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func setPaddingView(strImgname: String,txtField: UITextField){
            let imageView = UIImageView(image: UIImage(named: strImgname))
            imageView.frame = CGRect(x: 10, y: 2, width: imageView.image!.size.width, height: imageView.image!.size.height)
            let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 35))
            paddingView.addSubview(imageView)
            txtField.leftViewMode = .always
            txtField.leftView = paddingView
    }
    @IBAction func tapOK(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: txtEmail.text!) { error in
            if error == nil {
                print("Send")
            } else {
                print("Failed")
            }
        }
    }
}
