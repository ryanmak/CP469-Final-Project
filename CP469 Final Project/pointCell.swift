//
//  pointCell.swift
//  CP469 Final Project
//
//  Created by Jonathan Wu on 2018-04-08.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class pointCell: UITableViewCell {

    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var upvote: UIButton!
    @IBOutlet weak var downvote: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        author.sizeToFit()
        comments.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
