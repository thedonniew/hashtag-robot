//
//  HashtagCell.swift
//  hashtag-robot
//
//  Created by Donnie Wang on 11/26/14.
//  Copyright (c) 2014 Donnie Wang. All rights reserved.
//

import UIKit

class HashtagCell: UITableViewCell {
    
    @IBOutlet var hashtagNameLabel: UILabel?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            hashtagNameLabel?.font = UIFont.boldSystemFontOfSize(15.0)
            self.backgroundColor = UIColor.grayColor()
        } else {
            hashtagNameLabel?.font = UIFont.systemFontOfSize(15.0)
            self.backgroundColor = nil
        }
    }
}
