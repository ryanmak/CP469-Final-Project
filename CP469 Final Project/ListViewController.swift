//
//  ListViewController.swift
//  CP469 Final Project
//
//  Created by Ryan Mak on 2018-04-03.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    // currently loaded posts will be stored here
    var posts:[Post] = []
    
    let REDDIT_SORTS:[String] = ["https://reddit.com/r/pics/hot/.json", "https://reddit.com/r/pics/top/.json", "https://reddit.com/r/pics/new/.json", "https://reddit.com/r/pics/rising/.json"]
    let OAUTH_REDDIT_SORTS:[String] = ["https://oauth.reddit.com/r/pics/hot/.json", "https://oauth.reddit.com/r/pics/top/.json", "https://oauth.reddit.com/r/pics/new/.json", "https://oauth.reddit.com/r/pics/rising/.json"]
    
    let defaultImage = "https://imgur.com/gallery/GiW4t"
    
    // url and raw data are variables as they can change as more posts are loaded
    var urlPath:String = ""
    var rawData = NSData()
    
    // reddit keeps the number of posts displayed at 25 posts/page.
    let NUM_OF_POSTS = 25
    var pageNumber = 1
    
    // after is used to keep track of pages
    // (i.e. a page will have an after "pointer" pointing to the next page)
    var after = String()
    
    var a = Authentication.sharedInstance
    
    // this is for the Hot, Top, New and Rising component of the app
    // each segment has its own sort. request that sort and refresh the table when clicked
    @IBOutlet weak var subredditSorts: UISegmentedControl!
    @IBAction func indexChanged(sender : UISegmentedControl) {
        // if user is not authenticaed, then use the regular url address
        if (!a.isAuthenticated) {
            switch sender.selectedSegmentIndex {
                // sort by Hot
                case 0:
                    print("first segement clicked")
                    urlPath = REDDIT_SORTS[0]
                // sort by Top
                case 1:
                    print("second segment clicked")
                    urlPath = REDDIT_SORTS[1]
                // sort by New
                case 2:
                    print("third segmnet clicked")
                    urlPath = REDDIT_SORTS[2]
                // sort by Rising
                case 3:
                    print("fourth segment clicked")
                    urlPath = REDDIT_SORTS[3]
                default:
                    break;
            }
        }
            // user has been authenticated. use the oauth url address
        else {
            switch sender.selectedSegmentIndex {
                // sort by Hot
                case 0:
                    print("first segement clicked")
                    urlPath = OAUTH_REDDIT_SORTS[0]
                // sort by Top
                case 1:
                    print("second segment clicked")
                    urlPath = OAUTH_REDDIT_SORTS[1]
                // sort by New
                case 2:
                    print("third segmnet clicked")
                    urlPath = OAUTH_REDDIT_SORTS[2]
                // sort by Rising
                case 3:
                    print("fourth segment clicked")
                    urlPath = OAUTH_REDDIT_SORTS[3]
                default:
                    break;
            }
        }
        // delete all previous entries and get json based on requested sort
        posts.removeAll()
        getJSON()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
    }
    
    // MARK: - TABLE FUNCTIONS
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PostCellView"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostCellView  else {
            fatalError("The dequeued cell is not an instance of PostCellView.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let post = posts[indexPath.row]
        
        cell.title.text = post.getTitle()
        cell.points.text = post.getPoints()
        cell.username.text = post.getUsername()
        cell.timestamp.text = post.getTimestamp()
        cell.postImage.image = post.getImage()
        
        // if user has reached bottom, load more posts
        if (indexPath.row == (NUM_OF_POSTS * pageNumber) - 1) {
            print("load more posts!")
            pageNumber = pageNumber + 1
            
            if (!a.isAuthenticated) {
                urlPath = urlPath + "?count=" + String(NUM_OF_POSTS * pageNumber) + "&after=" + after
            }
            else{
                urlPath = urlPath + "?count=" + String(NUM_OF_POSTS * pageNumber) + "&after=" + after
            }
            print(urlPath)
            getJSON()
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        return cell
    }
    
    // MARK: - DEFAULT FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize urlpath to the 'hot' sort
        urlPath = REDDIT_SORTS[0]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print("viewdidappear")
        posts.removeAll()
        getJSON()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - JSON/HELPER FUCNTIONS
    func getJSON(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url: NSURL = NSURL(string: urlPath)!
        var request: URLRequest = URLRequest(url: url as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // if user is authenticated, include the token in the HTTP request header
        if (a.isAuthenticated) {
            request.httpMethod = "GET"
            request.setValue("Bearer " + a.token, forHTTPHeaderField: "Authorization")
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            self.rawData = NSData(data:data!)
            print(self.rawData)
            self.parseJSON()
        }
        task.resume()
    }
    
    func parseJSON(){
        var json:[String:Any]? = nil
        
        // parse json
        do {
            json = try JSONSerialization.jsonObject(with: self.rawData as Data, options:.allowFragments) as? [String:Any]
        } catch {
            print("Error Parsing JSON")
            print(error)
        }

        // Get the sub-json block "data". This block contains contains "children", which we need
        let data = json!["data"] as! [String:Any]?
        
        // Get the after pointer
        after = data!["after"] as! String
        //print(after)
        
        // "children" contains the first 25 posts of the subreddit. This property was parsed as
        // a NSArray, but since we need to access the contents, cast as [[String:Any]] instead
        let postData = data!["children"] as! [[String:Any]]
        
        // convert individiaul posts to the Post object
        for i in 0...postData.count-1 {
            let p = postData[i]["data"] as! [String:Any]
            let title = String(describing:p["title"]!)
            let points = String(describing:p["score"]!)
            let username = String(describing:p["author"]!)
            
            // reddit gives time as a unix timestamp; we need to convert this to
            // a readable format, similar to the one reddit uses
            var timestamp = String(describing: p["created_utc"]!)
            timestamp = utsToRelativeTime(uts: timestamp)
            
            // reddit hides images in another series of nested json blocks. Call a
            // function to retrieve the URLs of the images
            let imageURL = getImageURL(post:p)
            
            // we need to download the image as a UIImage. Create an async task to download
            // the image and load all contents to a Post Object
            let url = URL(string: imageURL)
            var image = UIImage()
            
            let data = try? Data(contentsOf: url!)
            
            image = UIImage(data: data!)!
            let postObj = Post(title:title,points:points,username:username,timestamp:timestamp,image:image)
            self.posts.append(postObj)
            
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
//            print(title)
//            print(points)
//            print(username)
//            print(imageURL)
//            print("")
        }
    }
    // converts a unix timestamp into a relative time format (i.e. 1 hour ago, 5 days ago etc.)
    func utsToRelativeTime(uts:String)->String {
        let dateOfPost = NSDate(timeIntervalSince1970: Double(uts)!)
        let currentDate = NSDate()
        //print(dateOfPost)
        //print(currentDate)
        return ""
    }
    // returns the url of the image
    func getImageURL(post:[String:Any])->String{
        var imageURL = String()
        
        if (post["preview"] == nil) {
            return defaultImage
        }
        let preview = post["preview"] as! [String:Any]
        let images = preview["images"] as! [[String:Any]]
        let source = images[0]["source"] as! [String:Any]
        imageURL = String(describing: source["url"]!)

        return imageURL
    }


}

