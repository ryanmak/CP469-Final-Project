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
    private var isUpvoted:Bool
    private var isDownvoted:Bool
    private var isSaved:Bool
    
    init(title:String, points:String, username:String, timestamp:String, image:UIImage, up:Bool, down:Bool, saved:Bool) {
        self.pTitle = title
        self.pPoints = points
        self.pUsername = username
        self.pTimestamp = timestamp
        self.pImage = image
        self.isUpvoted = up
        self.isDownvoted = down
        self.isSaved = saved
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
    func getIsUpvoted()->Bool{
        return isUpvoted
    }
    func getIsDownvoted()->Bool{
        return isDownvoted
    }
    func getIsSaved()->Bool{
        return isSaved
    }
    func setIsUpvoted(b:Bool){
        self.isUpvoted = b
    }
    func setIsDownvoted(b:Bool){
        self.isDownvoted = b
    }
    func setIsSaved(b:Bool){
        self.isSaved = b
    }
}
