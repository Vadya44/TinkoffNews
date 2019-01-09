//
//  Result.swift
//  TinkoffNews
//
//  Created by Вадим Гатауллин on 09/01/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import Foundation


enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}
