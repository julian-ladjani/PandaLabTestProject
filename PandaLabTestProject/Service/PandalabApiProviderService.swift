//
//  PandalabApiProviderService.swift
//  PandaLabTestProject
//
//  Created by julian ladjani on 15/03/2019.
//  Copyright © 2019 julian ladjani. All rights reserved.
//

import UIKit
import Moya

enum PandalabApiProviderService {
    case getUserTeams(email: String)
}

extension PandalabApiProviderService: TargetType {
    var baseURL: URL { return URL(string: "https://balancer.pandalab.fr")! }
    var path: String {
        switch self {
        case .getUserTeams(_):
            return "/connect"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getUserTeams:
            return .post
        }
    }
    var task: Task {
        switch self {
        case let .getUserTeams(email):
            return .requestParameters(parameters: ["query": email], encoding: JSONEncoding.default)
        }
    }
    var sampleData: Data {
        switch self {
        case .getUserTeams(let email):
            return "[{\"team\": \"demo\",\"allEmails\": [\"\(email)\"], \"email\": \"\(email)\",\"login\": \"\(email)\",\"name\": \"Démonstration\",\"slug\"\"demo\",\"host\": \"demo.pandalab.fr\",\"api\": \"https://demo.pandalab.fr/api\",\"cdn\": \"https://demo.pandalab.fr/cdn\",\"ws\": \"wss://demo.pandalab.fr/events\"}]".utf8Encoded
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
