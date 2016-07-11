//
//  ResponseObjectSerializable.swift
//  NYTAPIPractice
//
//  Created by Eric Sze on 7/1/16.
//  Copyright © 2016 myApps. All rights reserved.
//

import Foundation
import Alamofire

public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}


public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

public enum BackendError: ErrorType {
    case Network(error: NSError)
    case DataSerialization(reason: String)
    case JSONSerialization(error: NSError)
    case ObjectSerialization(reason: String)
    case XMLSerialization(error: NSError)
}

extension Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: Response<T, BackendError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, BackendError> { request, response, data, error in
            guard error == nil else { return .Failure(.Network(error: error!)) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let
                    response = response,
                    responseObject = T(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    return .Failure(.ObjectSerialization(reason: "JSON could not be serialized into response object: \(value)"))
                }
            case .Failure(let error):
                return .Failure(.JSONSerialization(error: error))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

//extension    where Self: ResponseObjectSerializable {
//
//}

extension Alamofire.Request {
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: Response<[T], BackendError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], BackendError> { request, response, data, error in
            guard error == nil else { return .Failure(.Network(error: error!)) }
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            print(result)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    return .Success(T.collection(response: response, representation: value))
                } else {
                    return .Failure(. ObjectSerialization(reason: "Response collection could not be serialized due to nil response"))
                }
            case .Failure(let error):
                return .Failure(.JSONSerialization(error: error))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
