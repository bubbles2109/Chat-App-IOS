//
//  RegisterController.swift
//  Project
//
//  Created by Phamcuong on 06/11/2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

class RegisterController: UIViewController {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfRePassword: UITextField!
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    
    let storage = Storage.storage().reference()
    
    var imgData: Data!
    
    let fontConstant1 : CGFloat = 0.04
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbTitle.font = lbTitle.font.withSize(self.view.frame.height * fontConstant1)
        
        leftView(txtField: tfEmail, imgName: "icons8-envelope-30")
        leftView(txtField: tfPassword, imgName: "icons8-lock-30")
        leftView(txtField: tfRePassword, imgName: "icons8-lock-30")
        leftView(txtField: tfFullName, imgName: "icons8-person-30")
        
        tapImageView()
        
    }
    
    func tapImageView(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imgView.isUserInteractionEnabled = true
            imgView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let alert = UIAlertController(title: "Choose a place to get pictures", message: "", preferredStyle: .actionSheet)
        let btnCamera = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                self.showCameraPickerController()
            } else {
                print("khong co camera")
            }
        }
        let btnPhoto = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.showImagePickerController()
        }
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(btnCamera)
        alert.addAction(btnPhoto)
        alert.addAction(btnCancel)
        self.present(alert, animated: true, completion: nil)
        print("tap")
    }
    
    @IBAction func tapRegister(_ sender: Any) {
        let loader = self.loader()
        
        let email = tfEmail.text!
        let password = tfPassword.text!
        
        if password.isEmpty {
            self.stopLoader(loader: loader)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.addAlert(txtMessage: "Password cannot be blank")
            }
        } else if email.isEmpty {
            self.stopLoader(loader: loader)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.addAlert(txtMessage: "Email cannot be blank")
            }
        } else if password.count < 6 {
            self.stopLoader(loader: loader)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.addAlert(txtMessage: "Password must be longer than 6 characters")
            }
        }
        else {
            let emailRegEx = #"[A-Z0-9a-z._%+-]+\@gmail+\.com"#
            let range = NSRange(location: 0, length: email.utf16.count)
            let regex = try! NSRegularExpression(pattern: emailRegEx)
            if regex.firstMatch(in: email, options: [], range: range) != nil {
                Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                    
                    //let avatarRef = storageRef.child("images/\(email).jpg")
                    self!.storage.child("images/\(self!.tfEmail.text!).png").putData(self!.imgData, metadata: nil) { ( _, error) in
                        guard error == nil else {
                            print("loi up hinh")
                            return
                        }
                        self!.storage.child("images/\(self!.tfEmail.text!).png").downloadURL(completion: { url, error in
                            guard let url = url, error == nil else {
                                return
                            }
                            let urlString = url.absoluteString
                            print("Download URL: \(urlString)")
                            print("----------------\(password)")
                            UserDefaults.standard.set(urlString, forKey: "url")
                            
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = self!.tfFullName.text!
                            changeRequest?.photoURL = url.absoluteURL
                            changeRequest?.commitChanges { error in
                                let storyboard = UIStoryboard(name: "Main", bundle:nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "tabHome")
                                UIApplication.shared.windows.first?.rootViewController = vc
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                            }
                        })
                    }
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    guard let result = authResult, error == nil else {
                        print("------------\(error!)")
                        return
                    }
                    let user = result.user
                    print("Create user : \(user)")
                    strongSelf.navigationController?.dismiss(animated: true)
                }
            } else {
                self.stopLoader(loader: loader)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.addAlert(txtMessage: "Incorrect email format")
                }
            }
        }
    }
}
extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    func showCameraPickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chooseImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgView.image = chooseImg
            imgData = chooseImg.pngData()
        } else if let editImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imgView.image = editImg
            imgData = editImg.pngData()
        }
        imgView.image = UIImage(data: imgData)
        dismiss(animated: true)
    }
}




//            guard let imgData = chooseImg.pngData() else {
//                return
//            }
//            //let avatarRef = storageRef.child("images/\(email).jpg")
//            storage.child("images/\(tfEmail.text!).png").putData(imgData, metadata: nil) { ( _, error) in
//                guard error == nil else {
//                    print("loi up hinh")
//                    return
//                }
//                self.storage.child("images/\(self.tfEmail.text!).png").downloadURL(completion: { url, error in
//                    guard let url = url, error == nil else {
//                        return
//                    }
//                    let urlString = url.absoluteString
//                    print("Download URL: \(urlString)")
//                    UserDefaults.standard.set(urlString, forKey: "url")
//                })
//            }
