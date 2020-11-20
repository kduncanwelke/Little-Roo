//
//  GraphViewController.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 11/18/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import Charts
import GoogleMobileAds

class GraphViewController: UIViewController {
    
    @IBOutlet weak var graphView: LineChartView!
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var bottomBannerAd: GADBannerView!
    
    private let kickViewModel = KickViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateChart()
        
        bottomBannerAd.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bottomBannerAd.rootViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadBannerAd()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd()
        })
    }
    
    func loadBannerAd() {
        // load adaptive banner ad, get view width
        let frame = { () -> CGRect in
            if #available(iOS 11.0, *) {
                return view.frame.inset(by: view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        
        let viewWidth = frame.size.width
        bottomBannerAd.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bottomBannerAd.load(GADRequest())
    }
    
    func updateChart() {
        let entries = kickViewModel.getGraphData(type: type.selectedSegmentIndex, startDate: Date())
        
        print(entries)
        let dataSet = LineChartDataSet(entries: entries, label: "Kicks")
        let data = LineChartData(dataSets: [dataSet])
        
        // FIXME: format dates
        /*graphView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            let date = HealthDataManager.dates[Int(index)]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE"
            let currentDateString: String = dateFormatter.string(from: date)
            
            return currentDateString
        })*/
        
        graphView.noDataText = "No history available"
        dataSet.valueFont = UIFont.systemFont(ofSize: 12.0)
        dataSet.drawValuesEnabled = false
        graphView.data = data
        graphView.xAxis.labelFont = UIFont.systemFont(ofSize: 12.0)
        
        // FIXME: get label count depending on kick quantity
       // graphView.xAxis.setLabelCount(HealthDataManager.dates.count, force: true)
       // graphView.xAxis.labelCount = HealthDataManager.dates.count
        
        graphView.xAxis.labelPosition = .bottom
        graphView.xAxis.granularity = 1.0
        graphView.xAxis.granularityEnabled = true
        graphView.xAxis.drawGridLinesEnabled = false
        
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = UIColor.green
        dataSet.mode = .cubicBezier
        //dataSet.fillFormatter = CubicLineSampleFillFormatter()
        
        graphView.rightAxis.enabled = false
        graphView.leftAxis.enabled = true
        let emptyVals = [Highlight]()
        graphView.highlightValues(emptyVals)
        
        dataSet.colors = ChartColorTemplates.material()
        graphView.notifyDataSetChanged()
        
        // FIXME: format dates
        /*let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.setLocalizedDateFormatFromTemplate("ddMMyyyy")
        let string = formatter.string(from: HealthDataManager.dates[0])
        
        // FIXME: show data on tap? (if it shows on graph skip)
        let steps = Int(HealthDataManager.stepHistory[0])
        tapSteps.text = "\(steps) steps"
        tapDate.text = string
        tapDistance.text = "\(Int(HealthDataManager.distances[0])) \(Measures.preferred.rawValue)"*/
        
        graphView.animate(yAxisDuration: 0.5)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        updateChart()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
