//
//  VisualizationsViewController.swift
//  moodle
//
//  Created by Tony Chang on 3/16/22.
//

import UIKit
import Charts
import SPAlert
import FirebaseAuth

class ChartXAxisFormatter {
    var dateFormatter: DateFormatter?
    var referenceTimeInterval: TimeInterval?
    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}

extension ChartXAxisFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
        let referenceTimeInterval = referenceTimeInterval
        else {
            return ""
        }
        
        dateFormatter.timeZone = TimeZone.current
        
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }
}

class VisualizationsViewController: GradientViewController {

    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var intervalSegmentedControl: UISegmentedControl!
    @IBOutlet weak var genDataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let entries = generateForInterval(byAdding: .day, value: -7)
        if entries.count > 0 {
            generateLineChart(entries: entries)
            generatePieChart(entries: entries)
        }
        genDataButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 17)
    }
    
    func generateLineChart(entries raw: [Entry]) {
        
        // find scaling for minimum amount of time
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (raw.map {
            $0.date!.timeIntervalSince1970
        }).min() {
            referenceTimeInterval = minTimeInterval
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        
        var entries: [ChartDataEntry] = []
        for entry in raw {
            let date = entry.date!
            let timeInterval = date.timeIntervalSince1970
            let xVal = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            let yVal = entry.value(forKey: "rating") as! Int
            let entry = ChartDataEntry(x: xVal, y: Double(yVal))
            entries.append(entry)
        }
        
        // UI setting
        let set = LineChartDataSet(entries: entries, label: "mood")
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        set.mode = .cubicBezier
        set.fill = Fill.init(CGColor: CGColor.init(red: 0, green: 0, blue: 0.8, alpha: 1))
        set.drawFilledEnabled = true
        let data = LineChartData(dataSet: set)
        
        // draw x axis formation
        lineChart.data = data
        let xAxis = lineChart.xAxis
        xAxis.labelCount = 4
        xAxis.labelPosition = .bottom
        xAxis.drawLabelsEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
        xAxis.valueFormatter = xValuesNumberFormatter
        
        lineChart.animate(xAxisDuration: 1.5)
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.legend.enabled = false
    }
    
    func generatePieChart(entries raw: [Entry]) {
        
        var entries: [PieChartDataEntry] = []
        
        var counter: [Int] = [Int](repeating: 0, count: 11)
        
        for entry in raw {
            counter[Int(entry.rating)] += 1
        }
        let palette = MoodleColors.moodleColorsList
        
        // generate entries
        var setColors: [UIColor] = []
        for i in 1...10 {
            if counter[i] != 0 {
                let entry = PieChartDataEntry(value: Double(counter[i]), label: String(i))
                entries.append(entry)
                setColors.append(palette[i - 1])
            }
        }
        
        // set up pie chart
        let set = PieChartDataSet(entries)
        set.colors = setColors
        set.label = nil
        let data = PieChartData(dataSet: set)
        data.setValueTextColor(UIColor.black)
        
        // no doubles displayed, only ints
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        
        pieChart.data = data
        pieChart.animate(xAxisDuration: 1.5)
        pieChart.legend.enabled = false
        pieChart.holeColor = nil
        pieChart.entryLabelFont = UIFont.systemFont(ofSize: 25.0)
        pieChart.entryLabelColor = UIColor.black
    }

    @IBAction func refreshPressed(_ sender: Any) {
        let entries = generateForInterval(byAdding: .day, value: -7)
        intervalSegmentedControl.selectedSegmentIndex = 0
        if entries.count > 0 {
            generateLineChart(entries: entries)
            generatePieChart(entries: entries)
        }
    }
    
    @IBAction func generateDataPressed(_ sender: Any) {
        SPAlert.present(title: "Generating", preset: .spinner)
        Mock.clearData()
        Mock.generateData()
        SPAlert.dismiss()
        let entries = generateForInterval(byAdding: .day, value: -7)
        intervalSegmentedControl.selectedSegmentIndex = 0
        if entries.count > 0 {
            generateLineChart(entries: entries)
            generatePieChart(entries: entries)
        }
    }
    
    private func generateForInterval(byAdding component: Calendar.Component, value: Int) -> [Entry]{
        let calendar = Calendar.current
        let cur = Date()
        let prev = calendar.date(byAdding: component, value: value, to: cur)
        guard let user = Auth.auth().currentUser?.email else { abort() }
        
        var entries = Data.retrieveData(username: user, beginning: prev!, end: cur)
        entries = entries.sorted {
            $0.date! < $1.date!
        }
        return entries
    }
    
    @IBAction func intervalDidChange(_ sender: Any) {
        var entries: [Entry]
        switch (intervalSegmentedControl.selectedSegmentIndex) {
        case 0:
//          one week
            entries = generateForInterval(byAdding: .day, value: -7)
        case 1:
//          one month
            entries = generateForInterval(byAdding: .month, value: -1)
        case 2:
//          3 months
            entries = generateForInterval(byAdding: .month, value: -3)
        case 3:
//          6 months
            entries = generateForInterval(byAdding: .month, value: -6)
        case 4:
//          1 year
            entries = generateForInterval(byAdding: .year, value: -1)
        case 5:
//          all time (currently hard-coded to 20 years)
            entries = generateForInterval(byAdding: .year, value: -20)
        default:
            abort()
        }
        if entries.count > 0 {
            generateLineChart(entries: entries)
            generatePieChart(entries: entries)
        }
    }
}
