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
    @IBOutlet weak var cancelUnlimited: UIButton!
    
    @IBOutlet weak var typeDescription: UILabel!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var countdownTimer: UILabel!
    @IBOutlet weak var complete: UILabel!
    
    @IBOutlet weak var recentKick: UILabel!
    @IBOutlet weak var howLongAgo: UILabel!
    @IBOutlet weak var recordKickButton: UIButton!
    
    @IBOutlet weak var currentHour: UILabel!
    @IBOutlet weak var kicksPerCurrentHour: UILabel!
    
    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var kicksPerCurrentDay: UILabel!
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var confirmView: UIView!
    
    @IBOutlet weak var bottomBannerAd: GADBannerView!
    
    // MARK: Variables
    
    private let kickViewModel = KickViewModel()
    private let timerViewModel = TimerViewModel()
    var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        kickViewModel.loadKicks()
        
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' hh:mm a"
        
        NotificationCenter.default.addObserver(self, selector: #selector(endSession), name: NSNotification.Name(rawValue: "endSession"), object: nil)
        
        bottomBannerAd.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bottomBannerAd.rootViewController = self
        
        configureView()
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
    
    @objc func endSession() {
        stop()
    }
    
    func configureView() {
        recordKickButton.alpha = 0.5
        recordKickButton.isEnabled = false
        countdownTimer.isHidden = true
        cancelButton.isHidden = true
        cancelUnlimited.isHidden = true
        dimView.isHidden = true
        confirmView.isHidden = true
        
        if let last = kickViewModel.getLastKick() {
            recentKick.text = dateFormatter.string(from: last)
        } else {
            recentKick.text = "No Data"
        }
        
        currentDay.text = "\(kickViewModel.kicksToday())"
        currentHour.text = "\(kickViewModel.kicksHour())"
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
    
    func stop() {
        howLongAgo.text = "-:--"
        countdownTimer.isHidden = true
        recordKickButton.alpha = 0.5
        recordKickButton.isEnabled = false
        cancelButton.isHidden = true
        recordingType.isHidden = false
        dimView.isHidden = true
        confirmView.isHidden = true
        complete.animateFadeInSlow() {
            self.beginButton.isHidden = false
        }
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
            kickViewModel.newSession()
            countdownTimer.isHidden = false
            recordingType.isHidden = true
            beginButton.isHidden = true
            cancelButton.isHidden = false
            timerViewModel.beginTimer(label: countdownTimer)
        case .free:
            kickViewModel.newSession()
            recordingType.isHidden = true
            beginButton.isHidden = true
            cancelUnlimited.isHidden = false
        case .none:
            return
        }
        
        recordKickButton.alpha = 1.0
        recordKickButton.isEnabled = true
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        // button pressed to end timed session
        // confirm exiting timed mode
        print("cancel")
        dimView.isHidden = false
        confirmView.isHidden = false
    }
    
    @IBAction func recordKickPressed(_ sender: UIButton) {
        print("kick")
        timerViewModel.stopCountUpTimer()
        
        var type = kickViewModel.retrieveSessionType()
        
        switch type {
        case .hour:
            kickViewModel.addKick(date: Date(), time: howLongAgo.text ?? "-:--", isHourSession: true)
            recentKick.text = dateFormatter.string(from: Date())
        case .free:
            kickViewModel.addKick(date: Date(), time: howLongAgo.text ?? "-:--", isHourSession: false)
            recentKick.text = dateFormatter.string(from: Date())
        case .none:
            return
        }
        
        currentDay.text = "\(kickViewModel.kicksToday())"
        currentHour.text = "\(kickViewModel.kicksHour())"
        timerViewModel.beginCountUpTimer(label: howLongAgo)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        // if cancel confirmed for timed session
        timerViewModel.stopCountUpTimer()
        stop()
        timerViewModel.stopTimer()
    }
    
    @IBAction func cancelUnlimited(_ sender: UIButton) {
        // unlimited recording mode cancelled
        timerViewModel.stopCountUpTimer()
        howLongAgo.text = "-:--"
        beginButton.isHidden = false
        recordKickButton.alpha = 0.5
        recordKickButton.isEnabled = false
        cancelUnlimited.isHidden = true
        recordingType.isHidden = false
    }
    
    @IBAction func doNotCancel(_ sender: UIButton) {
        // cancellation message dismissed for timed session
        dimView.isHidden = true
        confirmView.isHidden = true
    }
    
    
    @IBAction func seeHistory(_ sender: UIButton) {
        performSegue(withIdentifier: "seeHistory", sender: Any?.self)
    }
    
    @IBAction func seeGraph(_ sender: UIButton) {
        performSegue(withIdentifier: "seeGraph", sender: Any?.self)
    }
    
}

