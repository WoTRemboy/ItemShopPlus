//
//  ShopPageUITests.swift
//  ItemShopPlusUITests
//
//  Created by Roman Tverdokhleb on 10/7/24.
//

import XCTest

final class ShopPageUITests: XCTestCase {
    
    private var onboarding = false

    internal func testShopPageInfoStruct() throws {
        let app = XCUIApplication()
        app.launch()
        
        if onboarding {
            let skipStaticText = app.staticTexts["Skip"]
            XCTAssertTrue(skipStaticText.exists, "Skip button doesn't exist")
            
            skipStaticText.tap()
            
            let getStartedStaticText = app.staticTexts["Get started"]
            XCTAssertTrue(getStartedStaticText.exists, "Get started button don't exist")
            
            getStartedStaticText.tap()
        }
        
        let mainButton = app.buttons["Item Shop"]
        XCTAssertTrue(mainButton.exists, "Item Shop button doesn't exist")
        mainButton.tap()
        
        let itemShopNavigationBar = app.navigationBars["Item Shop"]
        XCTAssertTrue(itemShopNavigationBar.exists, "Navigation Bar doesn't exist")
        
        let infoButton = itemShopNavigationBar.buttons["info"]
        XCTAssertTrue(infoButton.exists, "Info button doesn't exist")
        infoButton.tap()
        
        let whatIsText = app.staticTexts["What is: "]
        XCTAssertTrue(whatIsText.exists, "What is label doesn't exist")
        let aboutRotationText = app.staticTexts["About rotation"]
        XCTAssertTrue(aboutRotationText.exists, "About rotation label doesn't exist")
        let remainingTimeText = app.staticTexts["Remaining time"]
        XCTAssertTrue(remainingTimeText.exists, "Remaining time label doesn't exist")
        
        let shopInfoNavigationBar = app.navigationBars["Shop Info"]
        XCTAssertTrue(shopInfoNavigationBar.exists, "Shop Info Navigation Bar doesn't exist")
        
        let cancelButton = shopInfoNavigationBar.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button doesn't exist")
        cancelButton.tap()
    }
    
    internal func testItemShopItemInfo() throws {
        let app = XCUIApplication()
        app.launch()
        
        if onboarding {
            let skipStaticText = app.staticTexts["Skip"]
            XCTAssertTrue(skipStaticText.exists, "Skip button doesn't exist")
            
            skipStaticText.tap()
            
            let getStartedStaticText = app.staticTexts["Get started"]
            XCTAssertTrue(getStartedStaticText.exists, "Get started button don't exist")
            
            getStartedStaticText.tap()
        }
        
        let mainButton = app.buttons["Item Shop"]
        XCTAssertTrue(mainButton.exists, "Item Shop button doesn't exist")
        mainButton.tap()
        
        let collectionViewsQuery = app.collectionViews
        let cell = collectionViewsQuery.cells.firstMatch.scrollViews.containing(.other, identifier: "Vertical scroll bar, 1 page").element
        cell.tap()
        
        let grantedCell = collectionViewsQuery.cells.firstMatch
        XCTAssertTrue(grantedCell.exists, "Collection granted cell doesn't exist")
        grantedCell.tap()
        
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.exists, "Navigation bar doesn't exist")
        
        let cancelButton = navigationBar.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button doesn't exist")
        cancelButton.tap()
    }
}
