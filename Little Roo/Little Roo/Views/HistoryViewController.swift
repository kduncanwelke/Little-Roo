//
//  HistoryViewController.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 11/12/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HistoryViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var typeSelection: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomBannerAd: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: IBActions
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
