//
//  DateFormatting.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.12.2023.
//

import UIKit

final class DateFormating {
    
    // MARK: - Quests Module
    
    static let dateFormatterQuests: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    static func differenceBetweenDates(date1: Date, date2: Date) -> String {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.weekOfMonth ,.day, .hour, .minute], from: date1, to: date2)
        
        if let weeks = components.weekOfMonth, let days = components.day, let hours = components.hour, let minutes = components.minute {
            return String(format: "%01dW %01dD %02dH %02dM", weeks, days, hours, minutes)
        }
        return "Time diff error..."
    }
    
    // MARK: - Shop Module
    
    static let dateFormatterDMY: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}


