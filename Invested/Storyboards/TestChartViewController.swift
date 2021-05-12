//
//  TestChartViewController.swift
//  Invested
//
//  Created by Ben Leembruggen on 3/5/21.
//

import UIKit
import Charts

class TestChartViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
    let goals = [6, 8, 26, 30, 8, 10]
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        customizeChart(dataPoints: players, values: goals.map{ Double($0) })
        // Do any additional setup after loading the view.
    }
    
}
