//
//  NewsText.swift
//  TinkoffNews
//
//  Created by Вадим Гатауллин on 09/01/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import Foundation


struct NewsText : Decodable {
    let response : ResponseText
}

struct ResponseText : Decodable {
    let text : String
}
