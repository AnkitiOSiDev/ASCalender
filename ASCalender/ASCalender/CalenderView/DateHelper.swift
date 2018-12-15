//
//  DateHelper.swift
//  ASCalender
//
//  Created by Ankit on 15/12/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import Foundation

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func isBetweenDates(beginDate: Date, endDate: Date) -> Bool
    {
        if self.compare(beginDate) == .orderedAscending
        {
            return false
        }
        
        if self.compare(endDate) == .orderedDescending
        {
            return false
        }
        
        return true
    }
    
    func isToday() -> Bool {
        let cal = Calendar.current
        let todayDayComponents = (cal as NSCalendar).components([.day,.month,.year], from: Date())
        let dateComponents = (cal as NSCalendar).components([.day,.month,.year], from: Date())
        return todayDayComponents.day == dateComponents.day && todayDayComponents.month == dateComponents.month && todayDayComponents.year == dateComponents.year
    }
    
    
}
