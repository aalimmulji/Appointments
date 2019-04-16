//
//  DateRange.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/15/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import Foundation

struct DateRange: Sequence {
    
    typealias Iterator = AnyIterator<Date>
    
    var calendar: Calendar
    var startDate: Date
    var endDate: Date?
    var component: Calendar.Component
    var step: Int
    
    func makeIterator() -> Iterator {
        
        precondition(step != 0, "Step should not be zero!")
        
        var current = startDate
        return AnyIterator {
            guard let next = self.calendar.date(byAdding: self.component,
                                                value: self.step,
                                                to: current) else {
                                                    return nil
            }
            
            let orderedType: ComparisonResult = self.step > 0 ?
                .orderedDescending :
                .orderedAscending
            if let last = self.endDate, next.compare(last) == orderedType {
                return nil
            }
            current = next
            return next
        }
    }
}

extension Calendar {
    func dateRange(from: Date, to: Date? = nil, component: Calendar.Component, by step: Int = 1) -> DateRange {
        return DateRange(calendar: self, startDate: from, endDate: to, component: component, step: step)
    }
}
