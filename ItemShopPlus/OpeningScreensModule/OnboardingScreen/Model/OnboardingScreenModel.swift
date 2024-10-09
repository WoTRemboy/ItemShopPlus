//
//  OnboardingScreenModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/23/24.
//

import SwiftUI

struct OnboardingStep: Hashable {
    
    // MARK: - Main Properties
    
    let name: String
    let description: String
    let image: Image
    
    // MARK: - Hashable Conformance
    
    internal func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(description)
    }
    
    static func == (lhs: OnboardingStep, rhs: OnboardingStep) -> Bool {
        return lhs.name == rhs.name &&
               lhs.description == rhs.description
    }
}

// MARK: - OnboardingStep Methods Extension

extension OnboardingStep {
    
    // Sets up the onboarding steps
    static func stepsSetup() -> [OnboardingStep] {
        let first = OnboardingStep(name: Texts.OnboardingScreen.widgetTitle,
                                   description: Texts.OnboardingScreen.widgetContent,
                                   image: .OnboardingScreen.widget)
        
        let second = OnboardingStep(name: Texts.OnboardingScreen.placeholderTitle,
                                    description: Texts.OnboardingScreen.placeholderContent,
                                    image: .OnboardingScreen.placeholder)
        
        let third = OnboardingStep(name: Texts.OnboardingScreen.iconTitle,
                                   description: Texts.OnboardingScreen.iconContent,
                                   image: .OnboardingScreen.appIcon)
        
        return [first, second, third]
    }
}

// MARK: - OnboardingButtonType

// Representing the type of onboarding button
enum OnboardingButtonType {
    case nextPage
    case getStarted
}
