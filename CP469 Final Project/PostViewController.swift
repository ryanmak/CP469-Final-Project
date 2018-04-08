//
//  PostViewController.swift
//  CP469 Final Project
//
//  Created by Jonathan Wu on 2018-04-07.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    var post: Post?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initWithPost(post:Post){
        self.post = post
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
