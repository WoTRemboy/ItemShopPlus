//
//  ShopPageUITests.swift
//  ItemShopPlusUITests
//
//  Created by Roman Tverdokhleb on 10/7/24.
//

import XCTest

final class ShopPageUITests: XCTestCase {
    
    /// A boolean flag to check whether onboarding should be displayed
    private var onboarding = false

    /// Tests the structure and presence of elements in the "Item Shop Info" section
    ///
    /// This test launches the app, navigates through any onboarding screens (if necessary), then verifies that the "Item Shop" button exists. After tapping the button, it navigates to the "Shop Info" page, and checks the existence of specific labels such as "What is", "About rotation", and "Remaining time"
    internal func testShopPageInfoStruct() throws {
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
        
        // Verify and tap the "Item Shop" button
        let mainButton = app.buttons["Item Shop"]
        XCTAssertTrue(mainButton.exists, "Item Shop button doesn't exist")
        mainButton.tap()
        
        // Verify the navigation bar and tap the "Info" button
        let itemShopNavigationBar = app.navigationBars["Item Shop"]
        XCTAssertTrue(itemShopNavigationBar.exists, "Navigation Bar doesn't exist")
        
        let infoButton = itemShopNavigationBar.buttons["info"]
        XCTAssertTrue(infoButton.exists, "Info button doesn't exist")
        infoButton.tap()
        
        // Verify the presence of labels on the "Shop Info" page
        let whatIsText = app.staticTexts["What is: "]
        XCTAssertTrue(whatIsText.exists, "What is label doesn't exist")
        let aboutRotationText = app.staticTexts["About rotation"]
        XCTAssertTrue(aboutRotationText.exists, "About rotation label doesn't exist")
        let remainingTimeText = app.staticTexts["Remaining time"]
        XCTAssertTrue(remainingTimeText.exists, "Remaining time label doesn't exist")
        
        // Verify the existence of the cancel button and close the screen
        let shopInfoNavigationBar = app.navigationBars["Shop Info"]
        XCTAssertTrue(shopInfoNavigationBar.exists, "Shop Info Navigation Bar doesn't exist")
        
        let cancelButton = shopInfoNavigationBar.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button doesn't exist")
        cancelButton.tap()
    }
    
    /// Tests navigating through and selecting an item in the "Item Shop"
    ///
    /// This test launches the app, navigates through onboarding (if necessary), then verifies that the "Item Shop" button exists. After tapping the button, it selects the first available item in the shop, verifies its details, and finally returns to the previous screen by tapping the "Cancel" button
    internal func testItemShopItemInfo() throws {
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
        
        // Verify and tap the "Item Shop" button
        let mainButton = app.buttons["Item Shop"]
        XCTAssertTrue(mainButton.exists, "Item Shop button doesn't exist")
        mainButton.tap()
        
        // Tap the first item in the collection view
        let collectionViewsQuery = app.collectionViews
        let cell = collectionViewsQuery.cells.firstMatch.scrollViews.containing(.other, identifier: "Vertical scroll bar, 1 page").element
        cell.tap()
        
        // Verify that the granted item cell exists and tap it
        let grantedCell = collectionViewsQuery.cells.firstMatch
        XCTAssertTrue(grantedCell.exists, "Collection granted cell doesn't exist")
        grantedCell.tap()
        
        // Verify the navigation bar and close the screen
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.exists, "Navigation bar doesn't exist")
        
        let cancelButton = navigationBar.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button doesn't exist")
        cancelButton.tap()
    }
}
