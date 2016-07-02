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
        self.headline = representation.valueForKeyPath("fields.item_name") as! String
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [NYTHeadlines] {
        var collection = [NYTHeadlines]()
        
        return collection
    }
}
