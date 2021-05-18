//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by 위대연 on 2021/05/18.
//

import UIKit
import CoreData

struct Person {
    var name:String
    var phoneNumber:String
    var shortcutNumber:Int
}

class ViewController: UIViewController {
    enum ButtonTag:Int {
        case save = 10
        case fetch
    }
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var phoneTextField:UITextField!
    @IBOutlet weak var shortcutTextField:UITextField!
    
    @IBOutlet weak var saveButton:UIButton!
    @IBOutlet weak var fetchButton:UIButton!
    
    var user:Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = Person(name: "", phoneNumber: "", shortcutNumber: -1)
        
        self.saveButton.tag = ButtonTag.save.rawValue
        self.saveButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        self.fetchButton.tag = ButtonTag.fetch.rawValue
        self.fetchButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    @objc func buttonAction(_ sender:UIButton) {
        guard let tag = ButtonTag(rawValue: sender.tag) else { return }
        switch tag {
            case .save :
                self.user?.name = self.nameTextField.text ?? ""
                self.user?.phoneNumber = self.phoneTextField.text ?? ""
                self.user?.shortcutNumber = Int(self.shortcutTextField.text ?? "") ?? -1
                if let person = self.user {
                    self.saveContact(person: person)
                } else {
                    print("Could not save")
                }
            case .fetch :
                if let person = self.fetchContact() {
                    self.user = person
                    self.nameTextField.text = person.name
                    self.phoneTextField.text = person.phoneNumber
                    self.shortcutTextField.text = String(person.shortcutNumber)
                } else {
                    print("fail fetch")
                }
        }
    }
    
    func saveContact(person:Person) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        if let entity = entity {
            let contact = NSManagedObject(entity: entity, insertInto: context)
            contact.setValue(person.name, forKey: "name")
            contact.setValue(person.phoneNumber, forKey: "phoneNumber")
            contact.setValue(person.shortcutNumber, forKey: "shortcutNumber")
            do {
                try context.save()
                print("save complete")
            } catch {
                print(error)
            }
        }
    }
    
    func fetchContact() -> Person? {
        var result:[Person]?
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let contact = try context.fetch(Contact.fetchRequest()) as! [Contact]
            
            result = [Person]()
            
            contact.forEach { item in
                let name = item.name ?? ""
                let phoneNumber = item.phoneNumber ?? ""
                let shortcutNumber:Int = Int(item.shortcutNumber)
                
                let person = Person(name: name, phoneNumber: phoneNumber, shortcutNumber: shortcutNumber)
                result?.append(person)
            }
            return result?.first
        } catch {
            print(error)
        }
        return nil
    }
    
    
}

