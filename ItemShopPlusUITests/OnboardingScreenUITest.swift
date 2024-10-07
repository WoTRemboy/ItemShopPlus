//
//  OnboardingScreenUITest.swift
//  ItemShopPlusUITests
//
//  Created by Roman Tverdokhleb on 10/7/24.
//

import XCTest

final class OnboardingScreenUITest: XCTestCase {

    internal func testOnbordingScreenWalkthrough() throws {
        let app = XCUIApplication()
        app.launch()
        
        let nextPageStaticText = app.staticTexts["Next page"]
        XCTAssertTrue(nextPageStaticText.exists, "Next page button don't exist")
        
        nextPageStaticText.tap()
        nextPageStaticText.tap()
        
        let getStartedStaticText = app.staticTexts["Get started"]
        XCTAssertTrue(getStartedStaticText.exists, "Get started button don't exist")
        
        getStartedStaticText.tap()

        let title = app.staticTexts["Fort Satellite"]
        XCTAssertTrue(title.exists, "Main page has not been loaded")
    }
}
