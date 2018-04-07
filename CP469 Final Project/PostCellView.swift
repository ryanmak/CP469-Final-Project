//
//  PostCellView.swift
//  CP469 Final Project
//
//  Created by Ryan Mak on 2018-04-03.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class PostCellView: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var upBtn: UIButton!
    @IBAction func upvote(_ sender: Any) {
        print("push")
        if upBtn.backgroundColor == UIColor.white {
            upBtn.backgroundColor = UIColor.orange
        }
        else if upBtn.backgroundColor == UIColor.orange {
            upBtn.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet weak var downBtn: UIButton!
    @IBAction func downvote(_ sender: Any) {
        if upBtn.backgroundColor == UIColor.white {
            upBtn.backgroundColor = UIColor.purple
        }
        else if upBtn.backgroundColor == UIColor.purple {
            upBtn.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet weak var starBtn: UIButton!
    @IBAction func save(_ sender: Any) {
        if upBtn.backgroundColor == UIColor.white {
            upBtn.backgroundColor = UIColor.yellow
        }
        else if upBtn.backgroundColor == UIColor.yellow {
            upBtn.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet weak var commentBtn: UIButton!
    @IBAction func comment(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("loaded")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
