//
//  ItemShopPlusUITestsLaunchTests.swift
//  ItemShopPlusUITests
//
//  Created by Roman Tverdokhleb on 10/2/24.
//

import XCTest

/// UI tests for verifying the app launch behavior
final class ItemShopPlusUITestsLaunchTests: XCTestCase {
    
    /// Indicates that the test should run once for each UI configuration in the target application
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    /// Sets up the test environment and disables test continuation after failure
    ///
    /// This method ensures that if a failure occurs, the test will stop immediately rather than continuing to run
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Tests the launch process of the app
    ///
    /// This method launches the app and captures a screenshot of the launch screen. The screenshot is then saved as an attachment for later inspection
    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Capture a screenshot after app launch
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
