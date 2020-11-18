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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timePassed: UILabel!
    
    
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
        timePassed.text = kickViewModel.getTimePassed(index: index, segment: segment)
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        
        if let kickDate = kickViewModel.getDate(index: index, segment: segment) {
            timeLabel.text = timeFormatter.string(from: kickDate)
            dateLabel.text = dateFormatter.string(from: kickDate)
        }
    }
}
