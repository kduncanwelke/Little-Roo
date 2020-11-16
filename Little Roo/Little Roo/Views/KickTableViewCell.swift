//
//  KickTableViewCell.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 11/12/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class KickTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: Variables
    
    private let kickViewModel = KickViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(index: IndexPath, segment: Int) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' hh:mm a"
        
        if let kickDate = kickViewModel.getDate(index: index, segment: segment) {
            timeLabel.text = dateFormatter.string(from: kickDate)
        }
    }
}
