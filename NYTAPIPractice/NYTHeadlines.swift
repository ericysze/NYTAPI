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
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.headline = representation.valueForKeyPath("headline.main") as! String
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
