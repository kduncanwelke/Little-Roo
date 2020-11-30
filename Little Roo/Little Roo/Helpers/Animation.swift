//
//  Animation.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 11/30/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func animateFadeInSlow(after: @escaping () -> Void) {
        UIView.animate(withDuration: 1.5, animations: {
            self.alpha = 1.0
        }, completion: { [unowned self] _ in
            UIView.animate(withDuration: 1.0) {
                self.alpha = 0.0
            }
            
            after()
        })
    }
}
