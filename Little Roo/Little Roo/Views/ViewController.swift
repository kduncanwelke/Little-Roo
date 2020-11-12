//
//  ViewController.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 10/29/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var recordingType: UISegmentedControl!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var typeDescription: UILabel!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var countdownTimer: UILabel!
    
    @IBOutlet weak var recentKick: UILabel!
    @IBOutlet weak var howLongAgo: UILabel!
    @IBOutlet weak var recordKickButton: UIButton!
    
    @IBOutlet weak var currentHour: UILabel!
    @IBOutlet weak var kicksPerCurrentHour: UILabel!
    
    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var kicksPerCurrentDay: UILabel!
    
    @IBOutlet weak var bottomBannerAd: GADBannerView!
    
    // MARK: Variables
    
    private let kickViewModel = KickViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        recordKickButton.alpha = 0.5
        recordKickButton.isEnabled = false
        countdownTimer.isHidden = true
        cancelButton.isHidden = true
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

    // MARK: IBActions
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if recordingType.selectedSegmentIndex == 0 {
            typeDescription.text = "Record kicks during a seated hour-long session, complete with countdown timer"
        } else {
            typeDescription.text = "Record kicks freely without the time commitment of an hour long session"
        }
        
        kickViewModel.setSessionType(index: recordingType.selectedSegmentIndex)
    }
    
    @IBAction func beginSession(_ sender: UIButton) {
        var type = kickViewModel.retrieveSessionType()
        
        switch type {
        case .hour:
            // start timer
            recordingType.isHidden = true
            beginButton.isHidden = true
            countdownTimer.isHidden = false
            cancelButton.isHidden = false
        case .free:
            recordingType.isHidden = true
            beginButton.isHidden = true
            cancelButton.isHidden = false
        case .none:
            return
        }
        
        recordKickButton.alpha = 1.0
        recordKickButton.isEnabled = true
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        // confirm exiting mode
        print("cancel")
        // if cancel confirmed
        countdownTimer.isHidden = true
        beginButton.isHidden = false
        recordKickButton.alpha = 0.5
        recordKickButton.isEnabled = false
        cancelButton.isHidden = true
        recordingType.isHidden = false
    }
    
    @IBAction func recordKickPressed(_ sender: UIButton) {
        print("kick")
    }
    
    @IBAction func seeHistory(_ sender: UIButton) {
        performSegue(withIdentifier: "seeHistory", sender: Any?.self)
    }
    
}

