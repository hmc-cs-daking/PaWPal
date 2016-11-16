//
//  LineChartViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 11/3/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit
import Charts

class LineChartViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var moodChart: BarChartView!
    @IBOutlet weak var moodSegment: UISegmentedControl!
    @IBOutlet weak var timeSegment: UISegmentedControl!
    
    let hours: [String] = ["8AM", "10AM", "12PM", "2PM", "4PM", "6PM", "8PM"]
    let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let happy: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    let confident: [Double] = [7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0]
    let calm: [Double] = [2.0, 2.0, 3.0, 2.0, 2.0, 3.0, 3.0]
    let friendly: [Double] = [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0]
    let awake: [Double] = [6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0]
    
    var currentData: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    var currentTimescale: [String] = ["8AM", "10AM", "12PM", "2PM", "4PM", "6PM", "8PM"]
    var currentMoodLabel: String = "Happiness"
    
    func updateMoodData(moodData: [Double], moodLabel: String){
        currentData = moodData
        currentMoodLabel = moodLabel
        moodChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        setChartData(currentTimescale, data: currentData, moodLabel: moodLabel)
    }
    
    func updateTimeData(timeScale: [String], moodLabel: String){
        currentTimescale = timeScale
        moodChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        setChartData(currentTimescale, data: currentData, moodLabel: moodLabel)
    }
    
    
    @IBAction func updateMoodAxis(sender: UISegmentedControl){
        if (sender.selectedSegmentIndex == 0){
            updateMoodData(happy, moodLabel: "Happiness")
        }
        else if (sender.selectedSegmentIndex == 1){
            updateMoodData(confident, moodLabel: "Confidence")
        }
        else if (sender.selectedSegmentIndex == 2){
            updateMoodData(calm, moodLabel: "Calmness")
        }
        else if (sender.selectedSegmentIndex == 3){
            updateMoodData(friendly, moodLabel: "Friendliness")
        }
        else if (sender.selectedSegmentIndex == 4){
            updateMoodData(awake, moodLabel: "Awakeness")
        }
    }
    
    @IBAction func updateTimeAxis(sender: UISegmentedControl){
        if (sender.selectedSegmentIndex == 0){
            updateTimeData(hours, moodLabel: currentMoodLabel)
        }
        else if (sender.selectedSegmentIndex == 1){
            updateTimeData(days, moodLabel: currentMoodLabel)
        }
    }
    
    func setChartData(timeAxis : [String], data: [Double], moodLabel: String) {
        // creating an array of data entries
//        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
//        for i in 0..<timeAxis.count{
//            yVals1.append(ChartDataEntry(value: data[i], xIndex: i))
//        }
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<timeAxis.count {
            let dataEntry = BarChartDataEntry(value: data[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
//        
        // create a data set with our array
        let chartDataSet: BarChartDataSet = BarChartDataSet(yVals: dataEntries, label: moodLabel)
        chartDataSet.axisDependency = .Left // Line will correlate with left axis values
        chartDataSet.setColor(UIColor.cyanColor().colorWithAlphaComponent(0.6)) // our line's opacity is 50%
//        set1.setCircleColor(UIColor.cyanColor().colorWithAlphaComponent(0.6))
//        set1.lineWidth = 2.0
//        set1.circleRadius = 6.0 // the radius of the node circle
//        set1.fillAlpha = 65 / 255.0
//        set1.fillColor = UIColor.cyanColor()
        //set1.highlightColor = UIColor.whiteColor()
        //set1.drawCircleHoleEnabled = true
        
        //create an array to store our BarChartDataSets
//        var dataSets : [BarChartDataSet] = [BarChartDataSet]()
//        dataSets.append(set1)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: BarChartData = BarChartData(xVals: timeAxis, dataSet: chartDataSet)
        data.setValueTextColor(UIColor.blackColor())
        
        //5 - finally set our data
        self.moodChart.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moodChart.delegate = self
        self.moodChart.descriptionText = "Tap node for details"
        
        //set color
        self.moodChart.descriptionTextColor = UIColor.tangerineColor()
        //self.moodChart.gridBackgroundColor = UIColor.whiteColor()
        self.moodChart.backgroundColor = UIColor(red: 189, green: 195, blue: 199)
        self.moodChart.noDataText = "No data provided"
        updateMoodData(happy, moodLabel: "Happiness")
        
        //testing dataprocessor
        DataProcessor.getWeekData(NSDate())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
