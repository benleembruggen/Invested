//
//  DashboardTableViewController.swift
//  Invested
//
//  Created by Ben Leembruggen on 28/4/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class DashboardTableViewController: UITableViewController {

    let SECTION_GRAPH = 0
    let SECTION_STOCKS = 1
    let CELL_GRAPH = "graphCell"
    let CELL_STOCK = "stockCell"
    
    var stockArray: [String] = []
    
    // store a refrence to the users document in firebase
    let docRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // on view appear get the current users positions and store in the stockArray
    override func viewWillAppear(_ animated: Bool) {
        // get the document
        docRef.getDocument { (document, error) in
            // check for error
            if let error = error {
                print("Error reteriving user data \(error)")
            } else {
                guard let doc = document else {return}
                // get the positions data and set to the array
                let data = doc.data()
                let positions = data!["positions"] as? [String]
                self.stockArray = positions ?? []
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_GRAPH:
                return 0
            case SECTION_STOCKS:
                return stockArray.count
            default:
                return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // return the header title for each section in the table view
        var text = ""
        
        switch section {
            case 0:
                text = "Dashboard"
            case 1:
                text = "Current Positions"
            default:
                text = ""
        }
        return text
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_STOCKS {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_STOCK, for: indexPath)
            cell.textLabel?.text = stockArray[indexPath.row]
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: CELL_STOCK, for: indexPath)
        }
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_STOCKS {
            return true
        }
        return false
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the table and update the firebase document
            stockArray.remove(at: indexPath.row)
            docRef.setData(["positions": stockArray])
            tableView.reloadSections([SECTION_STOCKS], with: .automatic)
        }    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
