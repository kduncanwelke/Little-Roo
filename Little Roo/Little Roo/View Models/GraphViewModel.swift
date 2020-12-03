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
            return "\(hour)am"
        } else if hour == 12 {
            return "\(hour)pm"
        } else if hour > 12 && hour < 24 {
            var newHour = hour - 12
            return "\(newHour)pm"
        } else {
            return "12am"
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
                let intified = Int(index - 1)
                var day = Calendar.current.date(byAdding: .day, value: -intified, to: date)!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EE \n dd"
                let currentDateString: String = dateFormatter.string(from: day)
        
                return currentDateString
            }
        })
    }
    
    func getColors() -> [NSUIColor] {
        var colors: [NSUIColor] = []
        
        for i in GraphManager.entries! {
            if i.y == 0 {
                colors.append(UIColor.clear)
            } else {
                colors.append(UIColor.green)
            }
        }
        
        return colors
    }
    
    func getLabelColors() -> [NSUIColor] {
        var colors: [NSUIColor] = []
        
        for i in GraphManager.entries! {
            if i.y == 0 {
                colors.append(UIColor.clear)
            } else {
                colors.append(UIColor.black)
            }
        }
        
        return colors
    }
}
