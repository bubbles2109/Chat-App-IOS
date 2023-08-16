//
//  Struct.swift
//  Project
//
//  Created by Phamcuong on 06/11/2022.
//

import Foundation
import UIKit

struct User {
    let id: String
    let email: String
    let fullName: String
    let linkAvatar: String
    var avatar: UIImage?
    
    init() {
        id = ""
        email = ""
        fullName = ""
        linkAvatar = ""
        avatar = UIImage(named: "icons8-person-30")
    }
    
    init(id: String, email: String, fullName: String, linkAvatar: String) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.linkAvatar = linkAvatar
        self.avatar = UIImage(named: "icons8-person-30")
    }
}
