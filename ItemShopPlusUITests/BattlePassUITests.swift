//
//  BattlePassUITests.swift
//  ItemShopPlusUITests
//
//  Created by Roman Tverdokhleb on 10/7/24.
//

import XCTest

final class BattlePassUITests: XCTestCase {

    private var onboarding = false

    internal func testBattlePassInfoStruct() throws {
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
        
        let passButton = app.buttons["Battle Pass"]
        XCTAssertTrue(passButton.exists, "Battle Pass button doesn't exist")
        passButton.tap()
        
        let itemShopNavigationBar = app.navigationBars["Battle Pass"]
        XCTAssertTrue(itemShopNavigationBar.exists, "Navigation Bar doesn't exist")
        
        let infoButton = itemShopNavigationBar.buttons["info"]
        XCTAssertTrue(infoButton.exists, "Info button doesn't exist")
        infoButton.tap()
        
        let whatIsText = app.staticTexts["Start date"]
        XCTAssertTrue(whatIsText.exists, "Start date label doesn't exist")
        let aboutRotationText = app.staticTexts["End date"]
        XCTAssertTrue(aboutRotationText.exists, "End date label doesn't exist")
        let remainingTimeText = app.staticTexts["Remaining time"]
        XCTAssertTrue(remainingTimeText.exists, "Remaining time label doesn't exist")
    }
    
    internal func testBattlePassItemInfo() throws {
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
        
        let passButton = app.buttons["Battle Pass"]
        XCTAssertTrue(passButton.exists, "Battle Pass button doesn't exist")
        passButton.tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.cells.firstMatch.tap()

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
