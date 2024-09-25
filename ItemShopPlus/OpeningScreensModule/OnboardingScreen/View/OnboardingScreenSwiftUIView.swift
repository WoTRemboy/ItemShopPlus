//
//  OnboardingScreenSwiftUIView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/23/24.
//

import SwiftUI

struct OnboardingScreenSwiftUIView: View {
    
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    internal var body: some View {
        VStack {
            skipButton
            content
            progressCircles
            actionButton
        }
    }
    
    private var skipButton: some View {
        HStack {
            Spacer()
            Button {
                viewModel.skipSteps()
            } label: {
                Text(Texts.OnboardingScreen.skip)
                    .font(.body)
                    .foregroundStyle(viewModel.buttonType == .nextPage ? Color.labelSecondary : Color.clear)
                    .padding(.horizontal)
            }
            .padding(.top)
        }
        .disabled(viewModel.buttonType == .getStarted)
        .animation(.easeInOut, value: viewModel.buttonType)
    }
    
    private var content: some View {
        TabView(selection: $viewModel.currentStep) {
            ForEach(0 ..< viewModel.stepsCount, id: \.self) { index in
                VStack(spacing: 16) {
                    viewModel.steps[index].image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .clipShape(.rect(cornerRadius: 30))
                    
                    Text(viewModel.steps[index].name)
                        .font(.largeTitle)
                        .padding(.top)
                    
                    Text(viewModel.steps[index].description)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private var progressCircles: some View {
        HStack {
            ForEach(0 ..< viewModel.stepsCount, id: \.self) { step in
                if step == viewModel.currentStep {
                    Rectangle()
                        .frame(width: 20, height: 10)
                        .clipShape(.rect(cornerRadius: 10))
                        .foregroundStyle(Color.blue)
                } else {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color.labelDisable)
                }
            }
        }
        .animation(.easeInOut, value: viewModel.currentStep)
    }
    
    private var actionButton: some View {
        Button {
            switch viewModel.buttonType {
            case .nextPage:
                viewModel.nextStep()
            case .getStarted:
                viewModel.getStarted()
            }
        } label: {
            switch viewModel.buttonType {
            case .nextPage:
                Text(Texts.OnboardingScreen.next)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            case .getStarted:
                Text(Texts.OnboardingScreen.started)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .minimumScaleFactor(0.4)
        
        .foregroundStyle(viewModel.buttonType == .nextPage ? Color.orange : Color.green)
        .tint(viewModel.buttonType == .nextPage ? Color.orange : Color.green)
        .buttonStyle(.bordered)
        
        .padding(.horizontal)
        .padding(.vertical, 30)
        
        .animation(.easeInOut, value: viewModel.buttonType)
    }
}

#Preview {
    OnboardingScreenSwiftUIView()
        .environmentObject(OnboardingViewModel())
}

