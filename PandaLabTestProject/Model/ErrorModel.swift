//
//  ErrorModel.swift
//  PandaLabTestProject
//
//  Created by julian ladjani on 15/03/2019.
//  Copyright © 2019 julian ladjani. All rights reserved.
//

import UIKit


import UIKit
import ObjectMapper

class ErrorModel: Mappable {
    
    public var errorString: String?
    
    required init?(map: Map) {
    }
    
    required init?(errorString: String) {
        self.errorString = errorString
    }
    
    required init?() {
        self.errorString = nil
    }
    
    func mapping(map: Map) {
        self.errorString <- map["error"]
    }
    
    public var description: String { return "\(errorString ?? "Unknown error")" }
    
}
