//
//  NewsTableViewController.swift
//  Invested
//
//  Created by Ben Leembruggen on 28/4/21.
//

import UIKit
import Firebase
import SafariServices


struct AllNewsData: Codable {
    var news: [NewsData]
}

struct NewsData: Codable {
    var headline: String
    var datetime: Int
    var url: URL
    
}

class NewsTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    let NEWS_CELL = "newsCell"
    var stockNewsArray: [NewsData] = []
    
    // store a refrence to the users document in firebase
    let docRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserStocks()
    }
    
    // MARK: - API Methods
    func getUserStocks() {
        // get the document
        docRef.getDocument { (document, error) in
            // check for error
            if let error = error {
                print("Error reteriving user data \(error)")
            } else {
                guard let doc = document, let data = doc.data() else {return}
                // get the positions data and set to the array
                let positions = data["positions"] as! [String]
                self.callAPIForNews(stockArray: positions)
            }
        }
    }
    
    
    func callAPIForNews(stockArray: [String]) {
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
                    let allStockNews = try decoder.decode(Dictionary<String, AllNewsData>.self, from: data)
                    self.filterNewsData(stockArray: stockArray, allStockNews: allStockNews)
                   
                } catch {
                    print("Error parsing JSON data \(error)")
                }
            }
        }
        task.resume()
    }
    
    
    func filterNewsData(stockArray: [String], allStockNews: [String:AllNewsData]) {
        // get data from the request and put into the stockNewsArray
        self.stockNewsArray = []
        for stock in stockArray {
            guard let newsForStock = allStockNews[stock]?.news else {break}
            
            // get the 3 latest articles for the given stock
            for i in 0...2 {
                self.stockNewsArray.append(newsForStock[i])
            }
        }
        
        // sort stock based off the release time
        self.stockNewsArray.sort(by: { $0.datetime > $1.datetime })
        
        DispatchQueue.main.async {
           
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // return the header title for each section in the table view
        var text = ""
        
        switch section {
        case 0:
            text = "Stock News"
        default:
            text = ""
        }
        return text
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockNewsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if the cell is clicked on it will take the user to the page (displayed inside the app)
        let vc = SFSafariViewController(url: stockNewsArray[indexPath.row].url)
        vc.delegate = self

        present(vc, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NEWS_CELL, for: indexPath) as! NewsTableViewCell
        let currentStock = stockNewsArray[indexPath.row]
        
        cell.headline?.text = currentStock.headline
        
        return cell
    }
}
