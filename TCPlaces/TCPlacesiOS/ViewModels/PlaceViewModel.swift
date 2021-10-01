//
//  PlaceViewModel.swift
//  TCPlacesiOS
//
//  Created by Suhayl Ahmed on 13/09/2021.
//

import Foundation

struct PlaceViewModel: Hashable {
    let placeName: String
    let population: Int
    let currency: String
    let dateString: String
    
    var date: Date {
        return DateFormatter.iso8601DateFormatter.date(from: dateString) ?? Date()
    }
    
    var formattedDate: String {
        return DateFormatter.presentableDateAndTimeFormatter.string(from: date)
    }
}

private extension DateFormatter {
    
    static let presentableDateAndTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        
        return dateFormatter
    }()
    
}
