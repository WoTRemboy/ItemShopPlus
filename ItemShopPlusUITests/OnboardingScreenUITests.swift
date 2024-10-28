//
//  OnboardingScreenUITests.swift
//  ItemShopPlusUITests
//
//  Created by Roman Tverdokhleb on 10/7/24.
//

import XCTest

final class OnboardingScreenUITests: XCTestCase {
    
    /// A boolean flag to check whether onboarding should be displayed
    private var onboarding = true

    /// Tests the complete walkthrough of the onboarding screen by navigating through the pages and verifying the final screen
    ///
    /// This test simulates tapping the "Next page" button twice, followed by "Get started." After the onboarding is completed, it verifies that the main page is loaded
    internal func testOnbordingScreenWalkthrough() throws {
        guard onboarding else { return }
        
        let app = XCUIApplication()
        app.launch()
        
        // Verify and tap the "Next page" button twice
        let nextPageStaticText = app.staticTexts["Next page"]
        XCTAssertTrue(nextPageStaticText.exists, "Next page button doesn't exist")
        
        nextPageStaticText.tap()
        nextPageStaticText.tap()
        
        // Verify and tap the "Get started" button
        let getStartedStaticText = app.staticTexts["Get started"]
        XCTAssertTrue(getStartedStaticText.exists, "Get started button doesn't exist")
        
        getStartedStaticText.tap()

        // Verify that the main page is loaded
        let title = app.staticTexts["Fort Satellite"]
        XCTAssertTrue(title.exists, "Main page has not been loaded")
    }
    
    /// Tests the skipping functionality of the onboarding screen by tapping "Skip" and verifying the final screen
    ///
    /// This test simulates tapping the "Skip" button directly and then "Get started." After the onboarding is skipped, it verifies that the main page is loaded
    internal func testOnbordingScreenSkip() throws {
        guard onboarding else { return }
        
        let app = XCUIApplication()
        app.launch()
        
        // Verify and tap the "Skip" button
        let skipStaticText = app.staticTexts["Skip"]
        XCTAssertTrue(skipStaticText.exists, "Skip button doesn't exist")
        
        skipStaticText.tap()
        
        // Verify and tap the "Get started" button
        let getStartedStaticText = app.staticTexts["Get started"]
        XCTAssertTrue(getStartedStaticText.exists, "Get started button don't exist")
        
        getStartedStaticText.tap()

        // Verify that the main page is loaded
        let title = app.staticTexts["Fort Satellite"]
        XCTAssertTrue(title.exists, "Main page has not been loaded")
    }
}
