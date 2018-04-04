//
//  Post.swift
//  CP469 Final Project
//
//  Created by Ryan Mak on 2018-04-03.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class Post: NSObject {
    private let pTitle:String
    private let pPoints:String
    private let pUsername:String
    private let pTimestamp:String
    private var pImage:UIImage
    
    init(title:String, points:String, username:String, timestamp:String, image:UIImage) {
        self.pTitle = title
        self.pPoints = points
        self.pUsername = username
        self.pTimestamp = timestamp
        self.pImage = image
    }
    
    func getTitle()->String {
        return pTitle
    }
    func getPoints()->String {
        return pPoints
    }
    func getUsername()->String {
        return pUsername
    }
    func getTimestamp()->String {
        return pTimestamp
    }
    func getImage()->UIImage {
        return pImage
    }
}
