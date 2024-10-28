//
//  CommonLogicMethods.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.02.2024.
//

import Foundation

/// A  class that contains common logic methods used throughout the app
final class CommonLogicMethods {
    
    /// Capitalizes the first letter of each word in the given string. It also replaces underscores with spaces
    /// - Parameter input: A string that may contain words with underscores
    /// - Returns: A new string where the first letter of each word is capitalized, and underscores are replaced with spaces
    static func capitalizeFirstLetter(input: String) -> String {
        var capitalizedWords = [String]()
        
        // Replace underscores with spaces to separate words
        let dirtyWords = input.replacingOccurrences(of: "_", with: " ")
        let words = dirtyWords.components(separatedBy: " ")
        
        // Capitalize the first letter of each word
        for word in words {
            if let firstLetter = word.first {
                let capitalizedWord = String(firstLetter).uppercased() + String(word.dropFirst())
                capitalizedWords.append(capitalizedWord)
            }
        }
        
        // Join the capitalized words back into a single string
        let result = capitalizedWords.joined(separator: " ")
        return result
    }
}
