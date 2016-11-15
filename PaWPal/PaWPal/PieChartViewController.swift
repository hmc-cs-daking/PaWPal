//
//  PieChartViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 11/3/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit
import Charts

class PieChartViewController: UIViewController {
    
//    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        setChart(months, values: unitsSold)
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Int(arc4random_uniform(256))
            let green = Int(arc4random_uniform(256))
            let blue = Int(arc4random_uniform(256))
            
            let color = UIColor(red: red, green: green, blue: blue)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
    }
    
}
