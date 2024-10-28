//
//  BattlePassUITests.swift
//  ItemShopPlusUITests
//
//  Created by Roman Tverdokhleb on 10/7/24.
//

import XCTest

final class BattlePassUITests: XCTestCase {
    
    /// Flag to check if the onboarding screen is displayed
    private var onboarding = false

    /// Tests the Battle Pass information screen structure
    ///
    /// The method launches the app, checks if onboarding screens are present, skips them if necessary, then navigates to the Battle Pass section, verifies the presence of the info button, and checks for the existence of relevant Battle Pass information (e.g., Start Date, End Date, and Remaining Time)
    internal func testBattlePassInfoStruct() throws {
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
        
        // Navigate to Battle Pass section
        let passButton = app.buttons["Battle Pass"]
        XCTAssertTrue(passButton.exists, "Battle Pass button doesn't exist")
        passButton.tap()
        
        // Check for the existence of the Navigation Bar
        let itemShopNavigationBar = app.navigationBars["Battle Pass"]
        XCTAssertTrue(itemShopNavigationBar.exists, "Navigation Bar doesn't exist")
        
        // Check for the existence of the info button and tap it
        let infoButton = itemShopNavigationBar.buttons["info"]
        XCTAssertTrue(infoButton.exists, "Info button doesn't exist")
        infoButton.tap()
        
        // Verify the presence of labels on the "Battle Pass Info" page
        let whatIsText = app.staticTexts["Start date"]
        XCTAssertTrue(whatIsText.exists, "Start date label doesn't exist")
        let aboutRotationText = app.staticTexts["End date"]
        XCTAssertTrue(aboutRotationText.exists, "End date label doesn't exist")
        let remainingTimeText = app.staticTexts["Remaining time"]
        XCTAssertTrue(remainingTimeText.exists, "Remaining time label doesn't exist")
    }
    
    /// Tests the Battle Pass item details screen
    ///
    /// This method launches the app, skips the onboarding screens if necessary, navigates to the Battle Pass section, taps on an item to view its details, and verifies the presence of relevant navigation elements (e.g., Cancel button)
    internal func testBattlePassItemInfo() throws {
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
        
        // Navigate to Battle Pass section
        let passButton = app.buttons["Battle Pass"]
        XCTAssertTrue(passButton.exists, "Battle Pass button doesn't exist")
        passButton.tap()
        
        // Select the first item in the Battle Pass
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.cells.firstMatch.tap()

        // Verify the item details screen is shown
        let grantedCell = collectionViewsQuery.cells.firstMatch
        XCTAssertTrue(grantedCell.exists, "Collection granted cell doesn't exist")
        grantedCell.tap()
        
        // Verify the navigation bar and cancel button are present
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.exists, "Navigation bar doesn't exist")
        
        let cancelButton = navigationBar.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button doesn't exist")
        cancelButton.tap()
    }
}
