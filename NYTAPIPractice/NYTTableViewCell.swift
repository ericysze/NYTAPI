//
//  NYTTableViewCell.swift
//  NYTAPIPractice
//
//  Created by Eric Sze on 7/4/16.
//  Copyright © 2016 myApps. All rights reserved.
//

import UIKit

class NYTTableViewCell: UITableViewCell {

    @IBOutlet weak var headlineLabel: UILabel!
    
    @IBOutlet weak var articleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
