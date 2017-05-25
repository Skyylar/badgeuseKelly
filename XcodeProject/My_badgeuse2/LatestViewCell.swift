//
//  LatestViewCell.swift
//  My_badgeuse2
//
//  Created by Amandine Laurent on 24/05/2017.
//  Copyright © 2017 Killian BAILLIF. All rights reserved.
//

import Foundation
import UIKit

class LatestViewCell: UITableViewCell {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var lateLabel: UILabel!
    @IBOutlet weak var absentLabel: UILabel!
    @IBOutlet weak var justifyButton: UIButton!
    @IBOutlet weak var missingButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        
    }
}
