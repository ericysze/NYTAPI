//
//  NYTHeadlines.swift
//  NYTAPIPractice
//
//  Created by Eric Sze on 7/1/16.
//  Copyright © 2016 myApps. All rights reserved.
//

import Alamofire

final class NYTHeadlines: ResponseObjectSerializable, ResponseCollectionSerializable {
    
    let headline: String
    var image: UIImage?
    
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.headline = representation.valueForKeyPath("headline.main") as! String
        
        let multimedia = representation.valueForKey("multimedia") as! [AnyObject]
        
//        if !multimedia.isEmpty {
            if let item = multimedia[0] as? Dictionary<String, AnyObject> {
                if let url = item["url"] {
                    
                    let nytURL = "https://www.nytimes.com/"
                    let imgURL = url as! String
                    let fullURL = nytURL + imgURL
                    
                    //                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    //                        self.image =  UIImage(data: (NSData(contentsOfURL: (NSURL(string:fullURL))!))!)!
                    //                    })
                    ImageLoader.sharedLoader.imageForUrl(fullURL, completionHandler:{(image: UIImage?, url: String) in
                        self.image = image
                    })
                }
            } else {
                self.image = nil
            }
//        }
    }

    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [NYTHeadlines] {
        var collection = [NYTHeadlines]()
        
        if let representation = representation as? Dictionary<String, AnyObject> {
            if let resp = representation["response"] as? Dictionary<String, AnyObject> {
                if let docs = resp["docs"] as? [AnyObject] {
                    for itemRep in docs {
                        if let item = NYTHeadlines(response: response, representation: itemRep) {
                            collection.append(item)
                        }
                    }
                }
            }
        }

        return collection
    }
    

}

extension CollectionType {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
