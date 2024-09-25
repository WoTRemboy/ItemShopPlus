//
//  OnboardingScreenModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/23/24.
//

import SwiftUI

struct OnboardingStep: Hashable {
    let name: String
    let description: String
    let image: Image
    
    internal func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(description)
    }
    
    static func == (lhs: OnboardingStep, rhs: OnboardingStep) -> Bool {
        return lhs.name == rhs.name &&
               lhs.description == rhs.description
    }
}

extension OnboardingStep {
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


enum OnboardingButtonType {
    case nextPage
    case getStarted
}
