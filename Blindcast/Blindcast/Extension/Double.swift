//
//  Double.swift
//  Blindcast
//
//  Created by Jan Anstipp on 25.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation

extension Double{
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self*divisor).rounded() / divisor
    }
}
