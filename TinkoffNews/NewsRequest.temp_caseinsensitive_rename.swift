//
//  newsRequest.swift
//  TinkoffNews
//
//  Created by Вадим Гатауллин on 09/01/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import Foundation


struct NewsRequest {
    var path: String {
        return "pageSize=20&pageOffset=0"
    }
    
    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension ModeratorRequest {
    static func from(site: String) -> ModeratorRequest {
        let defaultParameters = ["order": "desc", "sort": "reputation", "filter": "!-*jbN0CeyJHb"]
        let parameters = ["site": "\(site)"].merging(defaultParameters, uniquingKeysWith: +)
        return ModeratorRequest(parameters: parameters)
    }
}
