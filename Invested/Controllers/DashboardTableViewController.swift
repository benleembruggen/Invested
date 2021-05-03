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

struct AllStockData: Codable {
    var quote: StockData
}

struct StockData: Codable {
    var companyName: String
    var ytdChange: Double
}

class DashboardTableViewController: UITableViewController {
    
    let SECTION_GRAPH = 0
    let SECTION_ADD = 1
    let SECTION_STOCKS = 2
    let CELL_ADD = "addCell"
    let CELL_GRAPH = "graphCell"
    let CELL_STOCK = "stockCell"
    
    var stockArray: [String] = []
    var stockDataArray: [(String, Int)] = []
    var allStockData: [String: AllStockData] = [:]
    
    // store a refrence to the users document in firebase
    let docRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        }
        
        // generate initial API string
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/market/batch") else {
            print("URL not valid")
            return
        }
        
        // generate the string containing all the users stocks
        var stockString = ""
        for stock in stockArray {
            stockString += "\(stock),"
        }
        
        // add query params to the API string
        let queryItems = [URLQueryItem(name: "symbols", value: stockString),
                          URLQueryItem(name: "types", value: "quote"),
                          URLQueryItem(name: "token", value: Constants.API.APIKey)]
        let newUrl = url.appending(queryItems)!
        
        // make the request to the API and sotre data
        let task = URLSession.shared.dataTask(with: newUrl) { data, resposne, error in
            if let error = error {
                print("Error fetching api \(error)")
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    self.allStockData = try decoder.decode(Dictionary<String, AllStockData>.self, from: data)
                } catch {
                    print("Error parsing JSON data \(error)")
                }
            }
        }
        task.resume()
        
        // get data from the request and put into the stockDataArray
        stockDataArray = []
        for stock in stockArray {
            guard let currentStock = allStockData[stock]?.quote else {break}
            stockDataArray.append((currentStock.companyName, Int(currentStock.ytdChange*100)))
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_GRAPH:
            return 0
        case SECTION_ADD:
            return 1
        case SECTION_STOCKS:
            return stockDataArray.count
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
            // TODO change this for the custom cell
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_STOCK, for: indexPath) as! StockTableViewCell
            let currentStock = stockDataArray[indexPath.row]
            
            cell.nameLabel?.text = currentStock.0
            cell.priceLabel?.text = "\(currentStock.1.description)%"
            
            if (currentStock.1 >= 1) {
                cell.indicator?.text = "▲"
                cell.indicator?.textColor = .green
            } else if (currentStock.1 <= -1) {
                cell.indicator?.text = "▼"
                cell.indicator?.textColor = .red
            } else {
                cell.indicator?.text = "⬤"
                
            }
            
            return cell
        } else if indexPath.section == SECTION_ADD {
            let addCell = tableView.dequeueReusableCell(withIdentifier: CELL_ADD, for: indexPath)
            addCell.textLabel?.text = "Add a stock to portfolio"
            return addCell
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
            // delete the row from the table and update the firebase document
            stockArray.remove(at: indexPath.row)
            stockDataArray.remove(at: indexPath.row)
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
