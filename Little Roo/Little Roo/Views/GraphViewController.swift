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
    private let graphViewModel = GraphViewModel()
    
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
        graphViewModel.getData(type: type.selectedSegmentIndex, date: Date())
        
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
        
        dataSet.colors = ChartColorTemplates.material()
        graphView.notifyDataSetChanged()
        
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
