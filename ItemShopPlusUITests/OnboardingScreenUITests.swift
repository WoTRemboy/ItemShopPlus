//
//  OnboardingScreenUITests.swift
//  ItemShopPlusUITests
//
//  Created by Roman Tverdokhleb on 10/7/24.
//

import XCTest

final class OnboardingScreenUITests: XCTestCase {
    
    private var onboarding = true

    internal func testOnbordingScreenWalkthrough() throws {
        guard onboarding else { return }
        
        let app = XCUIApplication()
        app.launch()
        
        let nextPageStaticText = app.staticTexts["Next page"]
        XCTAssertTrue(nextPageStaticText.exists, "Next page button doesn't exist")
        
        nextPageStaticText.tap()
        nextPageStaticText.tap()
        
        let getStartedStaticText = app.staticTexts["Get started"]
        XCTAssertTrue(getStartedStaticText.exists, "Get started button doesn't exist")
        
        getStartedStaticText.tap()

        let title = app.staticTexts["Fort Satellite"]
        XCTAssertTrue(title.exists, "Main page has not been loaded")
    }
    
    internal func testOnbordingScreenSkip() throws {
        guard onboarding else { return }
        
        let app = XCUIApplication()
        app.launch()
        
        let skipStaticText = app.staticTexts["Skip"]
        XCTAssertTrue(skipStaticText.exists, "Skip button doesn't exist")
        
        skipStaticText.tap()
        
        let getStartedStaticText = app.staticTexts["Get started"]
        XCTAssertTrue(getStartedStaticText.exists, "Get started button don't exist")
        
        getStartedStaticText.tap()

        let title = app.staticTexts["Fort Satellite"]
        XCTAssertTrue(title.exists, "Main page has not been loaded")
    }
}
