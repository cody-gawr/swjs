//
//  Result.swift
//  autobrain
//
//  Created by hope on 11/12/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation

enum Result<T, E> {
    case success(T)
    case error(E)
}
