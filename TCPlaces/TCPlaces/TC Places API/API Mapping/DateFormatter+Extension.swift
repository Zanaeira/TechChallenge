//
//  DateFormatter+Extension.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 13/09/2021.
//

import Foundation

public extension DateFormatter {
    
    static let iso8601DateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter
    }()
    
}
