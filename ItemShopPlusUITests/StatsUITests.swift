//
//  StatsUITests.swift
//  ItemShopPlusUITests
//
//  Created by Roman Tverdokhleb on 10/8/24.
//

import XCTest

final class StatsUITests: XCTestCase {

    private var onboarding = false

    internal func testStatsWithLogin() throws {
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
        
        let statsButton = app.buttons["Stats"]
        XCTAssertTrue(statsButton.exists, "Stats button doesn't exist")
        statsButton.tap()
        
        let textField = app.textFields["Nickname"]
        XCTAssertTrue(textField.exists, "Nickname textfield doesn't exist")
        textField.tap()
        textField.typeText("WoTRemboy")
        
        let acceptButton = app.buttons["Accept"]
        XCTAssertTrue(acceptButton.exists, "Accept button doesn't exist")
        acceptButton.tap()
        
        let globalCell = app.collectionViews.staticTexts["Global"]
        globalCell.tap()
        
        let backButton = app.navigationBars["Global"].buttons["Stats"]
        XCTAssertTrue(backButton.exists, "Back button doesn't exist")
        backButton.tap()
    }
    
    internal func testStatsWithoutLogin() throws {
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
        
        let statsButton = app.buttons["Stats"]
        XCTAssertTrue(statsButton.exists, "Stats button doesn't exist")
        statsButton.tap()
        
        let globalCell = app.collectionViews.staticTexts["Global"]
        globalCell.tap()
        
        let backButton = app.navigationBars["Global"].buttons["Stats"]
        XCTAssertTrue(backButton.exists, "Back button doesn't exist")
        backButton.tap()
    }
}
