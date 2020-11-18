//
//  GraphViewController.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 11/18/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    
    @IBOutlet weak var graphView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateChart() {
        var entries: [ChartDataEntry] = []
        
        /*for i in 0..<7 {
            var entry = ChartDataEntry(x: Double(i), y: HealthDataManager.stepHistory[i])
            entries.append(entry)
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "Steps")
        let data = BarChartData(dataSets: [dataSet])
        
        graphView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            let date = HealthDataManager.dates[Int(index)]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE"
            let currentDateString: String = dateFormatter.string(from: date)
            
            return currentDateString
        })
        
        graphView.noDataText = "No step history available"
        dataSet.valueFont = UIFont.systemFont(ofSize: 12.0)
        dataSet.drawValuesEnabled = false
        graphView.data = data
        graphView.xAxis.labelFont = UIFont.systemFont(ofSize: 12.0)
        graphView.xAxis.setLabelCount(HealthDataManager.dates.count, force: true)
        graphView.xAxis.labelPosition = .bottom
        graphView.xAxis.granularity = 1.0
        graphView.xAxis.granularityEnabled = true
        graphView.xAxis.labelCount = HealthDataManager.dates.count
        graphView.xAxis.drawGridLinesEnabled = false
        
        graphView.rightAxis.enabled = false
        graphView.leftAxis.enabled = false
        let emptyVals = [Highlight]()
        graphView.highlightValues(emptyVals)
        
        dataSet.colors = ChartColorTemplates.joyful()
        graphView.notifyDataSetChanged()
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.setLocalizedDateFormatFromTemplate("ddMMyyyy")
        let string = formatter.string(from: HealthDataManager.dates[0])
        
        let steps = Int(HealthDataManager.stepHistory[0])
        tapSteps.text = "\(steps) steps"
        tapDate.text = string
        tapDistance.text = "\(Int(HealthDataManager.distances[0])) \(Measures.preferred.rawValue)"
        
        graphView.animate(yAxisDuration: 0.5)*/
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
