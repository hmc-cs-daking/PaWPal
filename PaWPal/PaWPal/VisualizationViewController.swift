//
//  VisualizationViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 10/24/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit
import Charts

class VisualizationViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var moodChart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moodChart.delegate = self
        self.moodChart.descriptionText = "Tap node for details"
        
        //set color
        self.moodChart.descriptionTextColor = UIColor.orangeColor()
        self.moodChart.gridBackgroundColor = UIColor.whiteColor()
        
        self.moodChart.noDataText = "No data provided"
        
        //time scale is days for right now
        setChartData(days)
    }
    
    let days = ["Sun", "Mon", "Tues", "Wed","Thus", "Friday", "Sat"]
    
    let dummyData = [3.0, 2.0, 3.0, 4.0, 4.0, 3.0, 6.0, 7.0]
    
    func setChartData(days : [String]) {
        // creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0..<days.count{
            yVals1.append(ChartDataEntry(value: dummyData[i], xIndex: i))
        }
        
        // create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "First Set")
        set1.axisDependency = .Left // Line will correlate with left axis values
        set1.setColor(UIColor.cyanColor().colorWithAlphaComponent(0.6)) // our line's opacity is 50%
        set1.setCircleColor(UIColor.cyanColor().colorWithAlphaComponent(0.6))
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.cyanColor()
        //set1.highlightColor = UIColor.whiteColor()
        //set1.drawCircleHoleEnabled = true
        
        //create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: days, dataSets: dataSets)
        data.setValueTextColor(UIColor.blackColor())
        
        //5 - finally set our data
        self.moodChart.data = data
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
