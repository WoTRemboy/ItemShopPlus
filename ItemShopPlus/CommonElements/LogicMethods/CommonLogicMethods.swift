//
//  CommonLogicMethods.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.02.2024.
//

import Foundation

final class CommonLogicMethods {
    static func capitalizeFirstLetter(input: String) -> String {
        var capitalizedWords = [String]()
        let dirtyWords = input.replacingOccurrences(of: "_", with: " ")
        let words = dirtyWords.components(separatedBy: " ")
        
        for word in words {
            if let firstLetter = word.first {
                let capitalizedWord = String(firstLetter).uppercased() + String(word.dropFirst())
                capitalizedWords.append(capitalizedWord)
            }
        }
        let result = capitalizedWords.joined(separator: " ")
        return result
    }
}
