//
//  UIFont + Extensions.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

extension UIFont {
    
    // SFProDisplay
    // Bold
    static func H1() -> UIFont? {
        UIFont.init(name: "SFProDisplay-Bold", size: 24)
    }
    
    // SFProText
    // Semibold
    static func H2() -> UIFont? {
        UIFont.init(name: "SFProText-Semibold", size: 20)
    }
    
    static func T1Semibold() -> UIFont? {
        UIFont.init(name: "SFProText-Semibold", size: 17)
    }
    
    static func T2Semibold() -> UIFont? {
        UIFont.init(name: "SFProText-Semibold", size: 15)
    }
    
    static func T3Semibold() -> UIFont? {
        UIFont.init(name: "SFProText-Semibold", size: 13)
    }
    
    // Regular
    static func T1Regular() -> UIFont? {
        UIFont.init(name: "SFProText-Regular", size: 17)
    }
    
    static func T2Regular() -> UIFont? {
        UIFont.init(name: "SFProText-Regular", size: 15)
    }
    
    static func T3Regular() -> UIFont? {
        UIFont.init(name: "SFProText-Regular", size: 13)
    }
    
    static func T4Regular() -> UIFont? {
        UIFont.init(name: "SFProText-Regular", size: 11)
    }
    
    static func T5Regular() -> UIFont? {
        UIFont.init(name: "SFProText-Regular", size: 10)
    }
}
