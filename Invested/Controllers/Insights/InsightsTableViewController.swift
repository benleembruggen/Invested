//
//  InsightsTableViewController.swift
//  Invested
//
//  Created by Ben Leembruggen on 28/4/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class InsightsTableViewController: UITableViewController {
    
    let ADD_SECTION = 0
    let POST_SECTION = 1
    let addCell = "addPostCell"
    let postCell = "postCell"
    
    var postArray: [Post] = []
    let docRef = Firestore.firestore().collection("posts")
    
    func getPosts() {
        postArray = []
        // get the document
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let post = document.data()
                    self.postArray.append(Post(likes: post["likes"] as! Int, stock: post["stock"] as! String, description: post["description"] as! String, tip: post["tip"] as! String))
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.showSpinner()
        getPosts()
    }
   
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // return the header title for each section in the table view
        var text = ""
        
        switch section {
        case 1:
            text = "Recent posts"
        default:
            text = ""
        }
        return text
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case ADD_SECTION:
            return 1
        case POST_SECTION:
            return postArray.count
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == POST_SECTION {
            let cell = tableView.dequeueReusableCell(withIdentifier: postCell, for: indexPath) as! PostTableViewCell
            let post = postArray[indexPath.row]
            
            cell.stockLabel?.text = post.stock
            cell.tipLabel?.text = post.tip
            cell.descriptionLabel?.text = post.description
            cell.selectionStyle = .none
            
            if post.tip == "Buy" {
                cell.tipLabel?.textColor = .green
            } else if post.tip == "Sell" {
                cell.tipLabel?.textColor = .red
            } else if post.tip == "Hold" {
                cell.tipLabel?.textColor = .lightGray
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: addCell, for: indexPath)
            cell.textLabel?.text = "Add a post"
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue controll so show the detail post for the selected post
        if segue.identifier == "postDetailSegue" {
            let destination = segue.destination as! PostDetailViewController
            let cellIndex = tableView.indexPathForSelectedRow?.row
            
            // set the information in the detail view
            if let cellIndex = cellIndex {
                let post = postArray[cellIndex]
                destination.titleText = post.stock
                destination.tipText = post.tip
                destination.postDescription = post.description
            }
        }
    }
}
