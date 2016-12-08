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
    
    let moodList: [String] = ["happy", "confident", "calm", "friendly", "awake"]
    let hours: [String] = ["12AM", "4AM", "8AM", "12PM", "4PM", "8PM", "12AM"]
    var days: [String] = []
    
    var currentData: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    var currentTimescale: [String] = ["12AM", "4AM", "8AM", "12PM", "4PM", "8PM", "12AM"]
    var currentMoodLabel: String = "happy"
    
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
        let tab = sender.selectedSegmentIndex
        updateLimitLine(moodList[tab], date: weekAgo(NSDate()))
        if (timeSegment.selectedSegmentIndex == 0){
            updateMoodData(AppState.sharedInstance.moodDictDay[moodList[tab]]!, moodLabel: moodList[tab])
        }
        else if (timeSegment.selectedSegmentIndex == 1){
            updateMoodData(AppState.sharedInstance.moodDictWeek[moodList[tab]]!, moodLabel: moodList[tab])
        }
        
    }
    
    func updateLimitLine(mood: String, date: NSDate){
        self.moodChart.leftAxis.removeAllLimitLines()
        if(AppState.sharedInstance.averageList[mood]! != 0){
            let ll = ChartLimitLine(limit: AppState.sharedInstance.averageList[mood]!, label: "Last Week's Average")
            ll.lineColor = UIColor.tangerineColor()
            self.moodChart.leftAxis.addLimitLine(ll)
        }
    }
    
    func weekAgo(date: NSDate) -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let weekAgoComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        weekAgoComponents.day -= 6
        weekAgoComponents.hour = 0
        weekAgoComponents.minute = 0
        weekAgoComponents.second = 0
        return calendar.dateFromComponents(weekAgoComponents)!
    }
    
    // when user taps timeSegment
    @IBAction func updateTimeAxis(sender: UISegmentedControl){
        if (sender.selectedSegmentIndex == 0){
            currentData = AppState.sharedInstance.moodDictDay[moodList[moodSegment.selectedSegmentIndex]]!
            updateTimeData(hours, moodLabel: currentMoodLabel)
        }
        else if (sender.selectedSegmentIndex == 1){
            currentData = AppState.sharedInstance.moodDictWeek[moodList[moodSegment.selectedSegmentIndex]]!
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
        let dataEntries: [BarChartDataEntry] = timeAxis.indices.map { BarChartDataEntry(value: data[$0], xIndex: $0) }
 
        // create a data set with our array
        let chartDataSet: BarChartDataSet = BarChartDataSet(yVals: dataEntries, label: moodLabel)
        chartDataSet.axisDependency = .Left // Line will correlate with left axis values
        chartDataSet.setColor(UIColor(red: 0, green: 129, blue: 242))
        let data: BarChartData = BarChartData(xVals: timeAxis, dataSet: chartDataSet)
        data.setValueTextColor(UIColor.blackColor())
        self.moodChart.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moodChart.delegate = self
        self.moodChart.descriptionText = "Displaying your mood"
        
        // initialize the chart setup
        self.moodChart.descriptionTextColor = UIColor.tangerineColor()
        self.moodChart.backgroundColor = UIColor(red: 189, green: 195, blue: 199)
        self.moodChart.noDataText = "No data provided"
        self.moodChart.leftAxis.customAxisMin = 0.0
        self.moodChart.leftAxis.customAxisMax = 8.0
        self.moodChart.rightAxis.enabled = false
        self.moodChart.leftAxis.enabled = false
        self.moodChart.leftAxis.drawGridLinesEnabled = false
        self.moodChart.xAxis.drawGridLinesEnabled = false
        self.moodChart.drawValueAboveBarEnabled = false
        
        generateWeekAxis(NSDate())
        
        //testing dataprocessor
        DataProcessor.getWeekAverage(weekAgo(NSDate()), completion: {self.updateLimitLine("happy", date: self.weekAgo(NSDate()))})
        DataProcessor.getDayData(NSDate(), completion: {self.updateMoodData(AppState.sharedInstance.moodDictDay["happy"]!, moodLabel: "happy")})
        DataProcessor.getWeekData(NSDate())
        
        print(AppState.sharedInstance.averageList)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
