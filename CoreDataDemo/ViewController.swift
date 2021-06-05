//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Sandeep Tomar on 03/06/21.
//

import UIKit
import CoreData

class ViewController: UIViewController  {

    @IBOutlet weak var tableView: UITableView!
    var names: [String] = ["Sandeep","tomar","new name", "testdataa"]
    var people: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                            forCellReuseIdentifier: "Cell")
        people.removeAll()
        for values in names {
            storeDataToDB(str: values)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try context.fetch(fetchRequest)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        if people.count > 0 {
            tableView.reloadData()
        }
       

    }
    
    
    func storeDataToDB(str:String) {
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appdelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        
      
            person.setValue(str, forKey: "name")
      
        // 4
         do {
           try managedContext.save()
           people.append(person)
            
           // tableView.reloadData()
         } catch let error as NSError {
           print("Could not save. \(error), \(error.userInfo)")
         }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath)
                 -> UITableViewCell {

    
    let person =  people[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                    for: indexPath)
    cell.textLabel?.text = person.value(forKey: "name")  as? String
    return cell
  }
}

