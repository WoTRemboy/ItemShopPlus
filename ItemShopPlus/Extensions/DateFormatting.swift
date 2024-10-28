//
//  DateFormatting.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.12.2023.
//

import UIKit

/// A class for date formatting and date difference calculations
final class DateFormating {
    
    // MARK: - Quests Module
    
    /// A date formatter used specifically for parsing quest-related dates. The format is set to `yyyy-MM-dd'T'HH:mm:ss.SSSZ`
    static let dateFormatterQuests: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    /// Calculates the difference between two dates and returns a formatted string
    /// - Parameters:
    ///   - date1: The earlier date
    ///   - date2: The later date
    /// - Returns: A string that represents the difference in weeks, days, hours, and minutes
    static func differenceBetweenDates(date1: Date, date2: Date) -> String {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.weekOfMonth ,.day, .hour, .minute], from: date1, to: date2)
        
        if let weeks = components.weekOfMonth, let days = components.day, let hours = components.hour, let minutes = components.minute {
            return String(format: "%01dW %01dD %02dH %02dM", weeks, days, hours, minutes)
        }
        return "Time diff error..."
    }
    
    // MARK: - Shop Module
    
    /// Formats a given date into a user-friendly string with numeric date components
    /// - Parameter date: The date to format
    /// - Returns: A string representing the date in a system numeric format (e.g., `MM/DD/YYYY`, `DD.MM.YYYY`)
    static func dateFormatterDefault(date: Date) -> String {
        date.formatted(date: .numeric, time: .omitted)
    }
}


