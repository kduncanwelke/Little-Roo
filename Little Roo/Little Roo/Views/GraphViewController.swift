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
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var bottomBannerAd: GADBannerView!
    
    private let kickViewModel = KickViewModel()
    private let graphViewModel = GraphViewModel()
    
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateChart()
        
        // start date is now, so you can't go back
        forwardButton.isEnabled = false
        formatDate()
        
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
        graphViewModel.getData(type: type.selectedSegmentIndex, date: date)
        
        guard let dataSet = graphViewModel.getDataSet(), let data = graphViewModel.getLineChartData() else {
            return
        }
        
        graphView.xAxis.valueFormatter = graphViewModel.formatAxis(type: type.selectedSegmentIndex, date: Date())
        
        graphView.noDataText = "No history available"
        dataSet.valueFont = UIFont.systemFont(ofSize: 12.0)
        graphView.data = data
        dataSet.valueColors = graphViewModel.getLabelColors()
        
        // format values to ints
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        data.setValueFormatter(formatter)
        
        // y-axis
        graphView.leftAxis.spaceBottom = 0.1
        graphView.rightAxis.enabled = false
        graphView.leftAxis.enabled = true
        
        // x-axis
        graphView.xAxis.labelFont = UIFont.systemFont(ofSize: 12.0)
        graphView.xAxis.avoidFirstLastClippingEnabled = true
        graphView.xAxis.labelPosition = .bottom
        graphView.xAxis.granularity = 1.0
        graphView.xAxis.granularityEnabled = true
        graphView.xAxis.drawGridLinesEnabled = false
        
        // values
        data.setDrawValues(true)
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = UIColor.green
        dataSet.mode = .cubicBezier
        dataSet.cubicIntensity = 0.2
        dataSet.circleColors = graphViewModel.getColors()
        
        
        let emptyVals = [Highlight]()
        graphView.highlightValues(emptyVals)
        
        //dataSet.colors = ChartColorTemplates.material()
        graphView.notifyDataSetChanged()
        
        graphView.animate(yAxisDuration: 0.5)
    }
    
    func formatDate() {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateString = dateFormatter.string(from: date)
        
        if type.selectedSegmentIndex == 0 {
            dayLabel.text = dateString
        } else {
            dayLabel.text = "Week of \(dateString)"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: IBActions
    
    @IBAction func forwardPressed(_ sender: UIButton) {
        // cancel if current date is today, you can't time travel
        if Calendar.current.isDateInToday(date) {
            return
        }
        
        if type.selectedSegmentIndex == 0 {
            // go back a day
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            updateChart()
        } else {
            // go back a week
            date = Calendar.current.date(byAdding: .day, value: 7, to: date)!
            updateChart()
        }
        
        formatDate()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        forwardButton.isEnabled = true
        
        if type.selectedSegmentIndex == 0 {
            // go back a day
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            updateChart()
        } else {
            // go back a week
            date = Calendar.current.date(byAdding: .day, value: -7, to: date)!
            updateChart()
        }
        
        if Calendar.current.isDateInToday(date) {
            forwardButton.isEnabled = false
        }
        
        formatDate()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        // pop back to current date when switching day/week view
        date = Date()
        updateChart()
        formatDate()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
