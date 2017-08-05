import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import CoreData

protocol ContactListUpdate {
    func contactListDidUpdate(updated: Bool)
}

open class NetworkManager: NSObject {
    //declarations
    var delegate : ContactListUpdate?
    var result = [[String:AnyObject]]()
    var coreDataManager = CoreDataManager(modelName: "demoMediaTest")
    var managedObjectContext: NSManagedObjectContext?
    var storedContacts : [Contact]?
    
    //manage contacts data
    open func manageContactList() {
        // check core data contents
        self.fetchData()
        
        // perform a network get if core data is empty
        if self.storedContacts?.count == 0 {
            self.getData()
        } else {
            // else update the table with what we fetched
            print("Contacts Previously Downloaded To Coredata")
            self.delegate?.contactListDidUpdate(updated: true)
        }
    }
    
    // builds datasource from existing coredata
    open func fetchData() {
        print("FETCH DATA CALLED")
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        self.managedObjectContext = self.coreDataManager.managedObjectContext
        do {
            self.storedContacts = try self.managedObjectContext?.fetch(request)
        } catch {
            print("Fetching Contacts Failed")
        }
    }
    
    // alamo request for network json
    open func getData() {
        print("GET DATA CALLED")
        // url
        Alamofire.request("http://demomedia.co.uk/files/contacts.json").responseJSON { (responseData) -> Void in
            if ((responseData.result.value) != nil) {
                // reponse
                let value = JSON(responseData.result.value!)
                // data
                if let resData = value[].arrayObject {
                    self.result = resData as! [[String:AnyObject]]
                }
                
                // formatted to the core data object
                self.managedObjectContext = self.coreDataManager.managedObjectContext
                
                for contact in self.result {
                    let newContact = Contact(context: self.managedObjectContext!)
                    newContact.surname = contact["surname"] as? String
                    newContact.firstname = contact["firstname"] as? String
                    newContact.email = contact["email"] as? String
                    newContact.phoneNumber = contact["phoneNumber"] as? String
                    newContact.createdAt = contact["createdAt"] as? String
                    newContact.address = contact["address"] as? String
                    newContact.updatedAt = contact["updatedAt"] as? String
                    newContact.title = contact["title"] as? String
                    // gets the contacts avatar
                    self.getAvatar(contact: newContact)
                    // add the new downloaded object to the array and update the table
                    self.storedContacts?.append(newContact)
                    self.delegate?.contactListDidUpdate(updated: true)
                }
                
                // save into coredata and update tableview
                do {
                    try self.managedObjectContext?.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
    }
    
    // get avatar
    open func getAvatar(contact: Contact) {
        print("GET AVATAR CALLED")
        // url of avatar checked from email
        if let email = contact.email {
            print("User Has An Email To Fetch With")
            let avatarURL = "http://api.adorable.io/avatar/\(email)"
            // get the avatar
            Alamofire.request(avatarURL).responseImage { response in
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    // save image to input contact
                    let contactAvatar = UIImagePNGRepresentation(image);
                    contact.avatar = contactAvatar as NSData?
                    self.delegate?.contactListDidUpdate(updated: true)
                    do {
                        try self.managedObjectContext?.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            }
        }
    }
    
}
