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
    }
    
    func getDataSet() -> LineChartDataSet? {
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
    
    func formatAxis(type: Int, date: Date) -> IAxisValueFormatter {
        DefaultAxisValueFormatter(block: {(index, _) in
            // hour view
            if type == 0 {
                var string = Int(index)
                return "\(string)"
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
