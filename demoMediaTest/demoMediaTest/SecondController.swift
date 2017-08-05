//
//  ViewController.swift
//  demoMediaTest
//
//  Created by Jack Warris on 01/08/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import UIKit

class SecondController: UIViewController {
    //outlets
    @IBOutlet weak var contactNameField: UILabel!
    @IBOutlet weak var contactAvatar: UIImageView!
    @IBOutlet weak var contactAddress: UILabel!
    @IBOutlet weak var contactPhone: UILabel!
    @IBOutlet weak var contactEmail: UILabel!
    @IBOutlet weak var contactCreated: UILabel!
    @IBOutlet weak var contactUpdated: UILabel!

    //declarations
    var passedContact : Contact!
    
    // view setup
    override func viewDidLoad() {
        super.viewDidLoad()
        applyContactInformationToCell()
        print("Loaded Contact \(self.passedContact)")
    }
    
    // map object to views
    func applyContactInformationToCell() {
        guard let contact = self.passedContact else {return}
        guard let firstName = contact.firstname else {return}
        guard let surname = contact.surname else {return}
        guard let address = contact.address else {return}
        guard let phone = contact.phoneNumber else {return}
        guard let email = contact.email else {return}
        guard let created = contact.createdAt else {return}
        guard let updated = contact.updatedAt else {return}

        // set unwrapped to textfields
        self.contactNameField.text = firstName + " " + surname
        self.contactAddress.text = "Address: " + address
        self.contactPhone.text = "Phone: " + phone
        self.contactEmail.text = "Email: " + email
        self.contactCreated.text = "Created: " + created
        self.contactUpdated.text = "Updated: " + updated
        
        // apply avatar
        if let contactAvatar = contact.avatar {
            let avatar = UIImage(data: (contactAvatar as Data))
            self.contactAvatar.image = avatar
        }
    }
    
}

