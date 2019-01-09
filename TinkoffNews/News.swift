//
//  News.swift
//  TinkoffNews
//
//  Created by Вадим Гатауллин on 09/01/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import Foundation

struct News : Decodable {
    let id : String
    let title : String
    let slug : String
    var reputation = 0
    
    init(displayName : String, reputation : Int?, id : String, slug : String) {
        self.title = displayName
        self.reputation = reputation ?? 0
        self.id = id
        self.slug = slug
    }
    
    mutating func incrementRep() {
        self.reputation = reputation + 1
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case slug = "slug"
    }
    
}
