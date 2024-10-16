//
//  FontExtensions.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

extension UIFont {
    
    /// Returns a bold system font with a size of 38, used for large titles
    /// - Returns: A `UIFont?` instance with bold weight
    static func largeTitle() -> UIFont? {
        UIFont.systemFont(ofSize: 38, weight: .bold)
    }
    
    /// Returns a medium-weight system font with a size of 30, used for displaying total prices
    /// - Returns: A `UIFont?` instance with medium weight
    static func totalPrice() -> UIFont? {
        UIFont.systemFont(ofSize: 30, weight: .medium)
    }
    
    /// Returns a medium-weight system font with a size of 25, used for segment titles
    /// - Returns: A `UIFont?` instance with medium weight
    static func segmentTitle() -> UIFont? {
        UIFont.systemFont(ofSize: 25, weight: .medium)
    }
    
    /// Returns a bold system font with a size of 25, used for placeholder titles
    /// - Returns: A `UIFont?` instance with bold weight
    static func placeholderTitle() -> UIFont? {
        UIFont.systemFont(ofSize: 25, weight: .bold)
    }
    
    /// Returns a medium-weight system font with a size of 20, used for titles
    /// - Returns: A `UIFont?` instance with medium weight
    static func title() -> UIFont? {
        UIFont.systemFont(ofSize: 20, weight: .medium)
    }
    
    /// Returns a medium-weight system font with a size of 17, used for headlines
    /// - Returns: A `UIFont?` instance with medium weight
    static func headline() -> UIFont? {
        UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    /// Returns a regular-weight system font with a size of 17, used for settings text
    /// - Returns: A `UIFont?` instance with regular weight
    static func settings() -> UIFont? {
        UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    /// Returns a light-weight system font with a size of 17, used for body text
    /// - Returns: A `UIFont?` instance with light weight
    static func body() -> UIFont? {
        UIFont.systemFont(ofSize: 17, weight: .light)
    }
    
    /// Returns a light-weight system font with a size of 15, used for subheadings
    /// - Returns: A `UIFont?` instance with light weight
    static func subhead() -> UIFont? {
        UIFont.systemFont(ofSize: 15, weight: .light)
    }
    
    /// Returns a medium-weight system font with a size of 13, used for footnotes
    /// - Returns: A `UIFont?` instance with medium weight
    static func footnote() -> UIFont? {
        UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    /// Returns a light-weight system font with a size of 13, used for light footnotes
    /// - Returns: A `UIFont?` instance with light weight
    static func lightFootnote() -> UIFont? {
        UIFont.systemFont(ofSize: 13, weight: .light)
    }
}
