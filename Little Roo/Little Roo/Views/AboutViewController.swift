//
//  AboutViewController.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 12/8/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
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
    
    @IBAction func privacyPolicyTapped(_ sender: UIButton) {
        guard let url = URL(string: "http://kduncan-welke.com/littlerooprivacy.php") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func admobPrivacyTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://support.google.com/admob/answer/6128543?hl=en") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
