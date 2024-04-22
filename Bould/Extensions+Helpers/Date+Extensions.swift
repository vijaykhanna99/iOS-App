//
//  Date+Extensions.swift
//  Bould
//
//  Created by Naveen on 17/10/23.
//

import Foundation

extension Date {
    
    var calender: Calendar {
        return Calendar(identifier: .gregorian)
    }
    
    var timeStampSince1970: Int {
        return Int(self.timeIntervalSince1970) * 1000
    }
    
    func isSameDay(_ date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func getDateComponent(_ component: Calendar.Component = .year) -> Int {
        let specificComponent = Calendar.current.component(component, from: self)
        return specificComponent
    }
    
    func stringFromDate(_ dateFormat: String = DateFormats.dd_MM_yyyy) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.amSymbol = Strings.am
        formatter.pmSymbol = Strings.pm
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    @available(iOS 13.0, *)
    func timeAgoDisplayIOS13() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func timeAgoDisplay() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .brief
        formatter.zeroFormattingBehavior = .dropAll
        formatter.calendar?.locale = Locale.current

        let result = formatter.string(from: self, to: Date())
        return result
    }
    
    static func dateFromString(_ serverTimeStamp: String?, format: String = DateFormats.yyyy_MM_dd_HH_mm_ss_SSSZ) -> Date? {
        guard let timeStamp = serverTimeStamp else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.date(from: timeStamp)
    }
    
    static func getPreviousYearByDifference(_ difference: Int) -> Int {
        return Date().getDateComponent(.year) - difference
    }
}
