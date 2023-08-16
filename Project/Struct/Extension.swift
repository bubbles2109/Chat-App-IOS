//
//  Extension.swift
//  Project
//
//  Created by Phamcuong on 06/11/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func leftView(txtField: UITextField, imgName: String){
        let imageView = UIImageView(image: UIImage(named: imgName))
        
        imageView.frame = CGRect(x: 10, y: 2, width: imageView.image!.size.width , height: imageView.image!.size.height)
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 35))
        paddingView.addSubview(imageView)
        txtField.leftViewMode = .always
        txtField.leftView = paddingView
    }
    
    func rightView(txtField: UITextField){

        
    }
}

extension UIImageView {
    func loadAvatar(link: String) {
        let queue: DispatchQueue = DispatchQueue(label: "loadImages", attributes: DispatchQueue.Attributes.concurrent, target: nil)
        let activity: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.frame = CGRect(x: self.frame.size.width / 2, y: self.frame.size.height / 2, width: 0, height: 0)
        activity.color = UIColor.blue
        self.addSubview(activity)
        activity.startAnimating()
        queue .sync {
            let url: URL = URL(string: link)!
            do {
            let data:Data = try Data(contentsOf: url)
                DispatchQueue.main.async(execute: {
                    activity.stopAnimating()
                    self.image = UIImage(data: data)
                })
            print("-----------------------load thanh cong")
            } catch {
                activity.stopAnimating()
                print("--------------------loi load hinh")
            }
        }
    }
}

extension UIViewController {
    func loader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let alertStyle = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        alertStyle.hidesWhenStopped = true
        alertStyle.startAnimating()
        alertStyle.style = .large
        alert.view.addSubview(alertStyle)
        present(alert, animated: true)
        return alert
    }
    
    func stopLoader(loader: UIAlertController){
        DispatchQueue.main.async {
            loader.dismiss(animated: true)
        }
    }
}

extension UIViewController {
    func addAlert(txtMessage: String){
        let alert = UIAlertController(title: "", message: txtMessage, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
