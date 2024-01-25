//
//  FontExtensions.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

extension UIFont {
    
    static func largeTitle() -> UIFont? {
        UIFont.systemFont(ofSize: 38, weight: .bold)
    }
    
    static func totalPrice() -> UIFont? {
        UIFont.systemFont(ofSize: 30, weight: .medium)
    }
    
    static func segmentTitle() -> UIFont? {
        UIFont.systemFont(ofSize: 25, weight: .medium)
    }
    
    static func title() -> UIFont? {
        UIFont.systemFont(ofSize: 20, weight: .medium)
    }
    
    static func headline() -> UIFont? {
        UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    static func body() -> UIFont? {
        UIFont.systemFont(ofSize: 17, weight: .light)
    }
    
    static func subhead() -> UIFont? {
        UIFont.systemFont(ofSize: 15, weight: .light)
    }
    
    static func footnote() -> UIFont? {
        UIFont.systemFont(ofSize: 13, weight: .medium)
    }
}
