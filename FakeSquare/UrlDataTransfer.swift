//
//  UrlDataTransfer.swift
//  FakeSquare
//
//  Created by alexk wix on 7/18/17.
//  Copyright © 2017 xxllexx. All rights reserved.
//

import Foundation

class UrlDataTransfer {
    static let sharedInstance = UrlDataTransfer()
    var transformedUrl: [String: Any]?
    var recievedUrl: String = "" {
        didSet {
            let decoded = recievedUrl.decodeUrl()
            let json = decoded.components(separatedBy: "=")
            transformedUrl = convertToDictionary(text: json[1]);
        }
    }
    
    private init() {}
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension String
{
    func encodeUrl() -> String
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    func decodeUrl() -> String
    {
        return self.removingPercentEncoding!
    }
    
}
