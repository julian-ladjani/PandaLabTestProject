//
//  TeamModel.swift
//  PandaLabTestProject
//
//  Created by julian ladjani on 15/03/2019.
//  Copyright © 2019 julian ladjani. All rights reserved.
//

import UIKit
import ObjectMapper

class TeamModel: Mappable {
    
    var team: String?
    var name: String?
    var slug: String?
    var host: String?
    var api: String?
    var cdn: String?
    var ws: String?
    var login: String?
    var email: String?
    var allEmails: [String]?
    var `public`: Bool?
    
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        self.team <- map["team"]
        self.name <- map["name"]
        self.slug <- map["slug"]
        self.host <- map["host"]
        self.api <- map["api"]
        self.cdn <- map["cdn"]
        self.ws <- map["ws"]
        self.login <- map["login"]
        self.email <- map["email"]
        self.allEmails <- map["allEmails"]
        self.public <- map["public"]
    }

}
