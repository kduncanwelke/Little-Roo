//
//  HistoryViewController.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 11/12/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: IBOutlets
    
    @IBOutlet weak var typeSelection: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomBannerAd: GADBannerView!
    
    // MARK: Variables
    
    private let kickViewModel = KickViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
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
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension HistoryViewController {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return kickViewModel.getHeading(section: section, segment: typeSelection.selectedSegmentIndex)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return kickViewModel.getSectionsTotal(type: typeSelection.selectedSegmentIndex)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var data = kickViewModel.retrieveSource(type: typeSelection.selectedSegmentIndex, section: section)
        
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kickCell", for: indexPath) as! KickTableViewCell
        
        cell.configure(index: indexPath, segment: typeSelection.selectedSegmentIndex)
        
        return cell
    }
}
