//
//  GraphViewModel.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 11/24/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import Charts

public class GraphViewModel {
    
    private var kickViewModel = KickViewModel()
    
    func getData(type: Int, date: Date) {
        GraphManager.entries?.removeAll()
        GraphManager.entries = kickViewModel.getGraphData(type: type, startDate: date)
        print("get data")
    }
    
    func getDataSet() -> LineChartDataSet? {
        print("get data set")
        GraphManager.dataSet = nil
        GraphManager.dataSet = LineChartDataSet(entries: GraphManager.entries, label: "Kicks")
        return GraphManager.dataSet
    }
    
    func getLineChartData() -> LineChartData? {
        if let dataSet = GraphManager.dataSet {
            return LineChartData(dataSets: [dataSet])
        } else {
            return nil
        }
    }
    
    func getAmPm(hour: Int) -> String {
        if hour < 12 {
            return "\(hour):00 am"
        } else if hour == 12 {
            return "\(hour):00pm"
        } else if hour > 12 && hour < 24 {
            var newHour = hour - 12
            return "\(newHour):00pm"
        } else {
            return "12:00am"
        }
    }
    
    func formatAxis(type: Int, date: Date) -> IAxisValueFormatter {
        DefaultAxisValueFormatter(block: {(index, _) in
            // hour view
            if type == 0 {
                let intified = Int(index)
                var hour = self.getAmPm(hour: intified)
                return hour
            } else {
                // week view
                let intified = Int(index)
                var day = Calendar.current.date(byAdding: .day, value: -intified, to: date)!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EE"
                let currentDateString: String = dateFormatter.string(from: day)
        
                return currentDateString
            }
        })
    }
}
