//
//  NYTHeadlineViewController.swift
//  NYTAPIPractice
//
//  Created by Eric Sze on 7/1/16.
//  Copyright © 2016 myApps. All rights reserved.
//

import UIKit
import Alamofire

class NYTHeadlineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!
    
    var data: [NYTHeadlines]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        tableView.registerNib(UINib(nibName: "NYTTableViewCell", bundle: nil), forCellReuseIdentifier: "NYTHeadlinesIdentifier")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let query = searchBar.text {
            // search searchTerm for whitespaes
            let whitespace = NSCharacterSet.whitespaceCharacterSet()
            
            let range = query.rangeOfCharacterFromSet(whitespace)
            
            if range != nil {
                // convert whitespaces to %20
                let adjustedQueryForWhitespaces = query.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                getRequest(adjustedQueryForWhitespaces)
            } else {
                getRequest(query)
            }
        }
    }

    func getRequest(query: String) {
        Alamofire.request(.GET, "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=\(query)")
            .responseCollection { (response: Response<[NYTHeadlines], BackendError>) in
                debugPrint(response)
                
                self.data = response.result.value!
                print(self.data)
                self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = self.data {
            return items.count
        } else {
            return 0
        }
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NYTHeadlinesIdentifier", forIndexPath: indexPath) as! NYTTableViewCell
        
        if let headline = data?[indexPath.row].headline, let imgURL = data?[indexPath.row].image {
            cell.headlineLabel.text = headline
            cell.articleImage.image = imgURL
        }
        
//        let imgURL = data?[indexPath.row].image
//        cell.articleImage.image = imgURL
        
        return cell
    }
    
    static func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
    }

}
