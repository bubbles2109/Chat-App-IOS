//
//  ViewController.swift
//  Project
//
//  Created by Phamcuong on 05/11/2022.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftView(txtField: tfEmail, imgName: "icons8-person-30")
        leftView(txtField: tfPassword, imgName: "icons8-lock-30")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    func validateAuth(){
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tabHome")
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    @IBAction func tapLogin(_ sender: Any) {
        let loader = self.loader()
        Auth.auth().signIn(withEmail: tfEmail.text!, password: tfPassword.text!, completion: { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController?.dismiss(animated: true)
            guard let result = authResult, error == nil else {
                print("Failed to login")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.addAlert(txtMessage: "Failed to login, please check your email or password again")
                }
                return
            }
            let user = result.user
            self?.stopLoader(loader: loader)
            print("Logged user : \(user)")
            let storyboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tabHome")
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        })
    }
    
    @IBAction func tapForgotPassword(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordController
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func tapRegister(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterController
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
}

