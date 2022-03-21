//
//  VisualizationsViewController.swift
//  moodle
//
//  Created by Tony Chang on 3/16/22.
//

import UIKit
import Charts

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

class VisualizationsViewController: UIViewController {

    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var pieChart: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generateLineChart()
        generatePieChart()
    }
    
    
    
    func generateLineChart() {
        let raw = Data.retrieveData(username: "user")
        
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
        
        
        var entries:[ChartDataEntry] = []
        
        for entry in raw {
            let date = entry.date!
            let timeInterval = date.timeIntervalSince1970
            let xVal = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            let yVal = entry.value(forKey: "rating") as! Int
            let entry = ChartDataEntry(x: xVal, y: Double(yVal))
            entries.append(entry)
        }
        
        let set = LineChartDataSet(entries: entries, label: "mood")
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        set.mode = .cubicBezier
        set.fill = Fill.init(CGColor: CGColor.init(red: 0, green: 0, blue: 0.8, alpha: 1))
        set.drawFilledEnabled = true
        let data = LineChartData(dataSet: set)
        
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
    
    func generatePieChart() {
        let raw = Data.retrieveData(username: "user")
        
        var entries:[PieChartDataEntry] = []
        
        var counter:[Int] = [Int](repeating: 0, count: 11)
        
        for entry in raw {
            counter[Int(entry.rating)] += 1
        }
        
        for i in 1..<11 {
            let entry = PieChartDataEntry(value: Double(counter[i]), label: String(i))
            entries.append(entry)
        }
        
        let set = PieChartDataSet(entries)
        set.colors = [UIColor.red, UIColor.blue, UIColor.green]
        set.label = nil
        let data = PieChartData(dataSet: set)
        
        pieChart.data = data
        pieChart.animate(xAxisDuration: 1.5)
    }

    @IBAction func refreshPressed(_ sender: Any) {
        generateLineChart()
        generatePieChart()
    }

}
