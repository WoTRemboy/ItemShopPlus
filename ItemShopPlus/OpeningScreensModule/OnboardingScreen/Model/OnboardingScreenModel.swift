//
//  OnboardingScreenModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/23/24.
//

import SwiftUI

/// A struct representing a step in the onboarding process
struct OnboardingStep: Hashable {
    
    // MARK: - Main Properties
    
    /// The title of the onboarding step
    let name: String
    /// The description of the onboarding step
    let description: String
    /// The image associated with the onboarding step
    let image: Image
    
    // MARK: - Hashable Conformance
    
    /// Hashes the essential components of the `OnboardingStep`
    internal func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(description)
    }
    
    /// Checks for equality between two `OnboardingStep` instances
    /// - Parameters:
    ///   - lhs: First `OnboardingStep` instance
    ///   - rhs: Second `OnboardingStep` instance
    /// - Returns: A boolean value about equivalence
    static func == (lhs: OnboardingStep, rhs: OnboardingStep) -> Bool {
        return lhs.name == rhs.name &&
               lhs.description == rhs.description
    }
}

// MARK: - OnboardingStep Methods Extension

extension OnboardingStep {
    
    /// Sets up the onboarding steps
    /// - Returns: Array of `OnboardingStep` instances
    static func stepsSetup() -> [OnboardingStep] {
        let first = OnboardingStep(name: Texts.OnboardingScreen.fortTitle,
                                   description: Texts.OnboardingScreen.fortContent,
                                   image: .OnboardingScreen.fort)
        
        let second = OnboardingStep(name: Texts.OnboardingScreen.videoTitle,
                                    description: Texts.OnboardingScreen.videoContent,
                                    image: .OnboardingScreen.play)
        
        let third = OnboardingStep(name: Texts.OnboardingScreen.widgetTitle,
                                   description: Texts.OnboardingScreen.widgetContent,
                                   image: .OnboardingScreen.widget)
        
        return [first, second, third]
    }
}

// MARK: - OnboardingButtonType

/// Representing the type of onboarding button
enum OnboardingButtonType {
    case nextPage
    case getStarted
}
