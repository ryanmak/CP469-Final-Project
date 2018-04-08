//
//  Post.swift
//  CP469 Final Project
//
//  Created by Ryan Mak on 2018-04-03.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class Post: NSObject {
    private let pId:String

    private let pTitle:String
    private let pPoints:String
    private let pUsername:String
    private let pTimestamp:String
    private let pComment:Int
    private let pLink:String
    private var pImage:UIImage
    private var isUpvoted:Bool
    private var isDownvoted:Bool
    private var isSaved:Bool
    
    init(id:String, title:String, points:String, username:String, timestamp:String, comment:Int, link:String, image:UIImage, up:Bool, down:Bool, saved:Bool) {
        self.pId = id
        self.pTitle = title
        self.pPoints = points
        self.pUsername = username
        self.pTimestamp = timestamp
        self.pComment = comment
        self.pLink = link
        self.pImage = image
        self.isUpvoted = up
        self.isDownvoted = down
        self.isSaved = saved
    }
    func getID()->String {
        return pId
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
    func getComments()->Int {
        return pComment
    }
    func getLink()->String {
        return pLink
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
