//
//  ViewController.swift
//  demoMediaTest
//
//  Created by Jack Warris on 01/08/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import UIKit
import CoreData

class FirstController: UIViewController, UITableViewDelegate, UITableViewDataSource, ContactListUpdate {
    
    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    //declarations
    var selectedContact : Contact?
    let networkManager = NetworkManager()
    
    //view setup
    override func viewWillAppear(_ animated: Bool) {
        self.networkManager.manageContactList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.networkManager.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    // table sections delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // table rows delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.networkManager.storedContacts?.count {
            return count
        }
        return 0
    }
    
    // table cell delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactCellTableViewCell
        // set name
        guard let contact = self.networkManager.storedContacts?[indexPath.row] else {return cell}
        cell.contactName.text = String((contact.firstname!) + " " + (contact.surname!))
        // set avatar
        guard let contactAvatar = contact.avatar else {return cell}
        let avatar = UIImage(data: (contactAvatar as Data))
        cell.contactAvatar.image = avatar
        // provide cell
        return cell
    }
    
    // passes the selected object and segues
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedContact = self.networkManager.storedContacts?[indexPath.row]
        performSegue(withIdentifier: "contactDetailSegue", sender: self)
    }
    
    // segue override
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactDetailSegue" {
            if let destination = segue.destination as? SecondController {
                destination.passedContact = self.selectedContact
            }
        }
    }
    
    //network callback refresh delegate
    func contactListDidUpdate(updated: Bool) {
        if updated == true {
            print("RAN DELEGATE UPDATE TABLE")
            self.tableView.reloadData()
        }
    }
    
    
}
