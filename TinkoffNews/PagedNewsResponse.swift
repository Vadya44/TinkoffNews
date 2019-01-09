//
//  PagedNewsResponse.swift
//  TinkoffNews
//
//  Created by Вадим Гатауллин on 09/01/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import Foundation

struct PagedNewsResponse: Decodable {
    let response : Response
    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
}

struct Response : Decodable {
    let news: [News]
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case news = "news"
        case total = "total"
    }
}
