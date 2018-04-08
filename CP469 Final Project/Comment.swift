//
//  Comment.swift
//  CP469 Final Project
//
//  Created by Jonathan Wu on 2018-04-08.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class Comment: NSObject {
    private let cUsername:String
    private let cBody:String
    private let cScore:String
    
    init(user:String, score:String, text:String) {
        self.cUsername = user
        self.cBody = text
        self.cScore = score
    }
    
    func getAuthor()->String {
        return cUsername
    }
    func getScore()->String {
        return cScore
    }
    func getText()->String {
        return cBody
    }
}
