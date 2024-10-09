//
//  OnboardingScreenViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/23/24.
//

import Foundation
import SwiftUI

/// A view model that manages the state and logic for the onboarding screen
final class OnboardingViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// A flag indicating whether to transfer to the main page
    @AppStorage(Texts.OnboardingScreen.userDefaultsKey) var transferMain: Bool = false
    /// The list of onboarding steps
    @Published internal var steps = OnboardingStep.stepsSetup()
    /// The current step index
    @Published internal var currentStep = 0
    
    /// The total number of steps
    internal var stepsCount: Int {
        steps.count
    }
    
    /// The type of the action button based on the current step
    internal var buttonType: OnboardingButtonType {
        if currentStep < steps.count - 1 {
            return .nextPage
        } else {
            return .getStarted
        }
    }
    
    // MARK: - Methods
    
    /// Advances to the next onboarding step
    internal func nextStep() {
        withAnimation(.easeInOut) {
            currentStep += 1
        }
    }
    
    /// Skips to the last onboarding step
    internal func skipSteps() {
        withAnimation(.easeInOut) {
            currentStep = steps.count - 1
        }
    }
    
    /// Completes the onboarding process and transitions to the main page
    internal func getStarted() {
        withAnimation {
            NotificationCenter.default.post(name: .transferToMainPage, object: nil)
            transferMain = true
        }
    }
}
