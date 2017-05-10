//
//  DeleteUsersViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 4/9/17.
//  Copyright © 2017 Pushbox, LLC'. All rights reserved.
//

import UIKit
import CoreData
class DeleteUsersTableViewController: UITableViewController {
    var users: [User]!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let searchResults = try! DatabaseController.getContext().fetch(fetchRequest)
            users = searchResults
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertConrtoller = UIAlertController(title: "Delete Student?", message: "You will not be able to undo deletion", preferredStyle: .alert)
        alertConrtoller.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            alertConrtoller.dismiss(animated: true, completion: nil)
        }))
        alertConrtoller.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            DatabaseController.getContext().delete(self.users[indexPath.item])
            DatabaseController.saveContext()
            alertConrtoller.dismiss(animated: true, completion: nil)
            tableView.reloadData()
        }))
        present(alertConrtoller, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! UITableViewCell
        cell.textLabel?.text = users[indexPath.item].name
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
