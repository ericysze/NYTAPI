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
    let imageURL: String?
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.headline = representation.valueForKeyPath("headline.main") as! String

        let nytURL = "https://www.nytimes.com/"
        
        if let multimedia = representation.valueForKey("multimedia") as? [AnyObject] where multimedia.count > 0,
            let item = multimedia[0] as? Dictionary<String, AnyObject>,
            let url = item["url"],
            let imgURL = url as? String {
            let fullURL = nytURL + imgURL
            self.imageURL = fullURL
        }
        else {
            self.imageURL = nil
        }
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
