//
//  OnboardingScreenViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/23/24.
//

import Foundation
import SwiftUI

final class OnboardingViewModel: ObservableObject {
    
    @AppStorage(Texts.OnboardingScreen.userDefaultsKey) var transferMain: Bool = false
    @Published internal var steps = OnboardingStep.stepsSetup()
    @Published internal var currentStep = 0
    
    internal var stepsCount: Int {
        steps.count
    }
    
    internal var buttonType: OnboardingButtonType {
        if currentStep < steps.count - 1 {
            return .nextPage
        } else {
            return .getStarted
        }
    }
    
    internal func nextStep() {
        withAnimation(.easeInOut) {
            currentStep += 1
        }
    }
    
    internal func skipSteps() {
        withAnimation(.easeInOut) {
            currentStep = steps.count - 1
        }
    }
    
    internal func getStarted() {
        withAnimation {
            NotificationCenter.default.post(name: .transferToMainPage, object: nil)
            transferMain = true
        }
    }
}
