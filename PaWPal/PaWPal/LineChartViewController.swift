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
    var days: [String] = []
    
    var currentData: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    var currentTimescale: [String] = ["8AM", "10AM", "12PM", "2PM", "4PM", "6PM", "8PM"]
    var currentMoodLabel: String = "Happiness"
    
    // helper function for when user taps moodSegment
    func updateMoodData(moodData: [Double], moodLabel: String){
        currentData = moodData
        currentMoodLabel = moodLabel
        moodChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        setChartData(currentTimescale, data: currentData, moodLabel: moodLabel)
    }
    
    // helper function for when user taps timeSegment
    func updateTimeData(timeScale: [String], moodLabel: String){
        currentTimescale = timeScale
        moodChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        setChartData(currentTimescale, data: currentData, moodLabel: moodLabel)
    }
    
    // when user taps moodSegment
    @IBAction func updateMoodAxis(sender: UISegmentedControl){
        if (sender.selectedSegmentIndex == 0){
            updateMoodData(AppState.sharedInstance.moodDict["happy"]!, moodLabel: "Happiness")
        }
        else if (sender.selectedSegmentIndex == 1){
            updateMoodData(AppState.sharedInstance.moodDict["confident"]!, moodLabel: "Confidence")
        }
        else if (sender.selectedSegmentIndex == 2){
            updateMoodData(AppState.sharedInstance.moodDict["calm"]!, moodLabel: "Calmness")
        }
        else if (sender.selectedSegmentIndex == 3){
            updateMoodData(AppState.sharedInstance.moodDict["friendly"]!, moodLabel: "Friendliness")
        }
        else if (sender.selectedSegmentIndex == 4){
            updateMoodData(AppState.sharedInstance.moodDict["awake"]!, moodLabel: "Awakeness")
        }
    }
    
    // when user taps timeSegment
    @IBAction func updateTimeAxis(sender: UISegmentedControl){
        if (sender.selectedSegmentIndex == 0){
            updateTimeData(hours, moodLabel: currentMoodLabel)
        }
        else if (sender.selectedSegmentIndex == 1){
            updateTimeData(days, moodLabel: currentMoodLabel)
        }
    }
    
    // helper function for generating the time axis for a week
    func generateWeekAxis(date: NSDate){
        let calendar = NSCalendar.currentCalendar()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE"
        var weekAxis: [String] = []
        
        for i in 6.stride(through: 0, by: -1) {
            let dayOfWeek: NSDate = calendar.dateByAddingUnit(.Day, value: -1*i, toDate: date, options: [])!
            weekAxis.append(formatter.stringFromDate(dayOfWeek))
        }
        days = weekAxis
    }
    
    func setChartData(timeAxis : [String], data: [Double], moodLabel: String) {
        // creating an array of data entries
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<timeAxis.count {
            let dataEntry = BarChartDataEntry(value: data[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
 
        // create a data set with our array
        let chartDataSet: BarChartDataSet = BarChartDataSet(yVals: dataEntries, label: moodLabel)
        chartDataSet.axisDependency = .Left // Line will correlate with left axis values
        chartDataSet.setColor(UIColor.cyanColor().colorWithAlphaComponent(0.6)) // our line's opacity is 60%
        
        let data: BarChartData = BarChartData(xVals: timeAxis, dataSet: chartDataSet)
        data.setValueTextColor(UIColor.blackColor())
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
        generateWeekAxis(NSDate())
        updateMoodData(AppState.sharedInstance.moodDict["happy"]!, moodLabel: "Happiness")
        
        //testing dataprocessor
        DataProcessor.getWeekData(NSDate())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
