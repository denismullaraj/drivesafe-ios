//
//  HomeView.swift
//  DriveSafe
//
//  Created by Denis Mullaraj on 04/03/2025.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var eyeTracker: EyeTracker
    @FocusState private var isMaxTimeFocused: Bool

    init(eyeTracker: EyeTracker) {
        self.eyeTracker = eyeTracker
    }
    
    var body: some View {
        VStack(spacing: 30) {
            HeaderView()
            
            InstructionView(maxTimeEyesCanBeClosed: Preferences.$maxTimeEyesCanBeClosed, isFocused: $isMaxTimeFocused)
            
            ActionButtonView(action: eyeTracker.schedule)
                .disabled(eyeTracker.isNotSupported)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onTapGesture {
            isMaxTimeFocused = false
        }
        .alert(isPresented: $eyeTracker.isNotSupported) {
            Alert(
                title: Text("Warning"),
                message: Text("App requires iPhone X or later to use the TrueDepth camera feature."),
                dismissButton: .cancel(Text("OK"))
            )
        }
    }
}

// MARK: - Subviews

private extension HomeView {
    struct HeaderView: View {
        var body: some View {
            VStack(spacing: 10) {
                Image(systemName: "car.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                
                Text("Drive Safe")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
    }
    
    struct InstructionView: View {
        @Binding var maxTimeEyesCanBeClosed: Int
        @FocusState.Binding var isFocused: Bool
        
        var body: some View {
            VStack(spacing: 15) {
                Text("You will hear an alarm anytime\nyou keep your eyes closed for more than:")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 5) {
                    TextField("2", value: $maxTimeEyesCanBeClosed, formatter: NumberFormatter())
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 40)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .focused($isFocused)

                    Text("seconds")
                        .font(.body)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    struct ActionButtonView: View {
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text("Keep Me Safe")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
        }
    }
}
