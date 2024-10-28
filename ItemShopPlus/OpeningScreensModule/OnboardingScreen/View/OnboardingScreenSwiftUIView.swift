//
//  OnboardingScreenSwiftUIView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/23/24.
//

import SwiftUI

/// A SwiftUI view that displays the onboarding screens
struct OnboardingScreenSwiftUIView: View {
    
    // MARK: - Properties
    
    /// The view model managing the onboarding logic
    @EnvironmentObject private var viewModel: OnboardingViewModel
    /// A state to handle button press animations
    @State private var isPressed = false
    
    // MARK: - Body
    
    internal var body: some View {
        VStack {
            skipButton
            content
            progressCircles
            actionButton
        }
    }
    
    // MARK: - Subviews
    
    /// The skip button at the top-right corner
    private var skipButton: some View {
        HStack {
            Spacer()
            Text(Texts.OnboardingScreen.skip)
                .font(.body)
                .foregroundStyle(viewModel.buttonType == .nextPage ? Color.labelSecondary : Color.clear)
                .padding(.horizontal)
                .padding(.top)
            
                .onTapGesture {
                    viewModel.skipSteps()
                }
            
        }
        .disabled(viewModel.buttonType == .getStarted)
        .animation(.easeInOut, value: viewModel.buttonType)
    }
    
    /// The main content displaying the onboarding steps
    private var content: some View {
        TabView(selection: $viewModel.currentStep) {
            ForEach(0 ..< viewModel.stepsCount, id: \.self) { index in
                VStack(spacing: 16) {
                    // Step Image
                    viewModel.steps[index].image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .clipShape(.rect(cornerRadius: 30))
                    
                    // Step Name
                    Text(viewModel.steps[index].name)
                        .font(.largeTitle)
                        .padding(.top)
                    
                    // Step Description
                    Text(viewModel.steps[index].description)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    /// The progress indicator showing the current step
    private var progressCircles: some View {
        HStack {
            ForEach(0 ..< viewModel.stepsCount, id: \.self) { step in
                if step == viewModel.currentStep {
                    // Current step indicator
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(Color.blue)
                        .transition(.scale)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
                } else {
                    // Not current step indicator
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color.labelDisable)
                        .transition(.scale)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
                }
            }
        }
        .animation(.easeInOut, value: viewModel.currentStep)
    }
    
    /// The action button at the bottom of the screen
    private var actionButton: some View {
        HStack {
            switch viewModel.buttonType {
            // Next Page button
            case .nextPage:
                Text(Texts.OnboardingScreen.next)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            // Get Started button
            case .getStarted:
                Text(Texts.OnboardingScreen.started)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .minimumScaleFactor(0.4)
        
        .foregroundColor(.white)
        .background(viewModel.buttonType == .nextPage ?
                    Color.OnboardingScreen.orange :
                    Color.OnboardingScreen.green)
        .cornerRadius(10)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        
        .padding(.horizontal)
        .padding(.vertical, 30)
        
        .animation(.easeInOut, value: viewModel.buttonType)
        .onLongPressGesture(minimumDuration: 0.0, maximumDistance: 50, pressing: { pressing in
                withAnimation(.snappy(duration: 0.2)) {
                    isPressed = pressing
                }
            }, perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    switch viewModel.buttonType {
                    case .nextPage:
                        // Transfer to next step
                        viewModel.nextStep()
                    case .getStarted:
                        // Transfer to Main page
                        viewModel.getStarted()
                    }
                }
            })
    }
}

// MARK: - Preview

#Preview {
    OnboardingScreenSwiftUIView()
        .environmentObject(OnboardingViewModel())
}

