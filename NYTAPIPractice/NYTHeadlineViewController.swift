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
    
    var headlines: [NYTHeadlines]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        searchBar.delegate = self
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
                
                self.headlines = response.result.value!
                print(self.headlines)
                self.tableView.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = self.headlines {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NYTHeadlinesIdentifier", forIndexPath: indexPath)
        let headline = headlines![indexPath.row].headline
        
        cell.textLabel!.text = headline
        
        return cell
    }
}
