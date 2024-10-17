//
//  StatsUITests.swift
//  ItemShopPlusUITests
//
//  Created by Roman Tverdokhleb on 10/8/24.
//

import XCTest

final class StatsUITests: XCTestCase {
    
    /// A boolean flag to check whether onboarding should be displayed
    private var onboarding = false

    /// Tests the Stats page with a nickname login
    ///
    /// This test launches the app, navigates through any onboarding screens (if necessary), enters a nickname in the stats login screen, and verifies that the "Accept" button works properly. It also navigates to the "Global" section and verifies the back button functionality
    internal func testStatsWithLogin() throws {
        let app = XCUIApplication()
        app.launch()
                        
        if onboarding {
            // If onboarding is enabled, navigate through it
            let skipStaticText = app.staticTexts["Skip"]
            XCTAssertTrue(skipStaticText.exists, "Skip button doesn't exist")
            
            skipStaticText.tap()
            
            let getStartedStaticText = app.staticTexts["Get started"]
            XCTAssertTrue(getStartedStaticText.exists, "Get started button don't exist")
            
            getStartedStaticText.tap()
        }
        
        // Verify and tap the "Stats" button
        let statsButton = app.buttons["Stats"]
        XCTAssertTrue(statsButton.exists, "Stats button doesn't exist")
        statsButton.tap()
        
        // Verify the nickname text field exists and type a nickname
        let textField = app.textFields["Nickname"]
        XCTAssertTrue(textField.exists, "Nickname textfield doesn't exist")
        textField.tap()
        textField.typeText("WoTRemboy")
        
        // Verify and tap the "Accept" button
        let acceptButton = app.buttons["Accept"]
        XCTAssertTrue(acceptButton.exists, "Accept button doesn't exist")
        acceptButton.tap()
        
        // Navigate to the "Global" section and verify its existence
        let globalCell = app.collectionViews.staticTexts["Global"]
        globalCell.tap()
        
        // Verify the back button functionality
        let backButton = app.navigationBars["Global"].buttons["Stats"]
        XCTAssertTrue(backButton.exists, "Back button doesn't exist")
        backButton.tap()
    }
    
    /// Tests the Stats page without logging in a nickname
    ///
    /// This test launches the app, navigates through any onboarding screens (if necessary), and navigates to the "Global" section in the Stats page without entering a nickname. It then verifies the back button functionality
    internal func testStatsWithoutLogin() throws {
        let app = XCUIApplication()
        app.launch()
                        
        if onboarding {
            // If onboarding is enabled, navigate through it
            let skipStaticText = app.staticTexts["Skip"]
            XCTAssertTrue(skipStaticText.exists, "Skip button doesn't exist")
            
            skipStaticText.tap()
            
            let getStartedStaticText = app.staticTexts["Get started"]
            XCTAssertTrue(getStartedStaticText.exists, "Get started button don't exist")
            
            getStartedStaticText.tap()
        }
        
        // Verify and tap the "Stats" button
        let statsButton = app.buttons["Stats"]
        XCTAssertTrue(statsButton.exists, "Stats button doesn't exist")
        statsButton.tap()
        
        // Navigate to the "Global" section and verify its existence
        let globalCell = app.collectionViews.staticTexts["Global"]
        globalCell.tap()
        
        // Verify the back button functionality
        let backButton = app.navigationBars["Global"].buttons["Stats"]
        XCTAssertTrue(backButton.exists, "Back button doesn't exist")
        backButton.tap()
    }
}
