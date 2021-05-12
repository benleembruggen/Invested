//
//  NewsTableViewController.swift
//  Invested
//
//  Created by Ben Leembruggen on 28/4/21.
//

import UIKit
import Firebase


struct AllNewsData: Codable {
    var news: [NewsData]
}

struct NewsData: Codable {
    var headline: String
    var datetime: Int
    var summary: String
    var image: URL
    var url: URL
    
}

class NewsTableViewController: UITableViewController {
    
    let NEWS_CELL = "newsCell"
    
    var stockArray: [String] = []
    var allStockNews: [String:AllNewsData] = [:]
    var stockNewsArray: [NewsData] = []
    
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
                          URLQueryItem(name: "types", value: "news"),
                          URLQueryItem(name: "token", value: Constants.API.APIKey)]
        let newUrl = url.appending(queryItems)!
        
        // make the request to the API and sotre data
        let task = URLSession.shared.dataTask(with: newUrl) { data, resposne, error in
            if let error = error {
                print("Error fetching api \(error)")
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    self.allStockNews = try decoder.decode(Dictionary<String, AllNewsData>.self, from: data)
                } catch {
                    print("Error parsing JSON data \(error)")
                }
            }
        }
        task.resume()
        
        // get data from the request and put into the stockNewsArray
        stockNewsArray = []
        for stock in stockArray {
            guard let newsForStock = allStockNews[stock]?.news else {break}
            
            // get the 3 latest articles for the given stock
            for i in 0...2 {
                stockNewsArray.append(newsForStock[i])
            }
        }
        
        // sort stock based off the release time
        stockNewsArray.sort(by: { $0.datetime > $1.datetime })
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stockNewsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NEWS_CELL, for: indexPath) as! NewsTableViewCell
        let currentStock = stockNewsArray[indexPath.row]
        let imageData = try! Data(contentsOf: currentStock.image)
        
        cell.headlineLabel?.text = currentStock.headline
        cell.imageRef.image = UIImage(data: imageData)
        
        return cell
    }
}
