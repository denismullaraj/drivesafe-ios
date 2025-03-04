//
//  EyeTrackingView.swift
//  DriveSafe
//
//  Created by Denis Mullaraj on 04/03/2025.
//

import SwiftUI

struct EyeTrackingView: View {
    @ObservedObject private var viewModel: EyeTrackingViewModel

    init(viewModel: EyeTrackingViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        viewModel.backgroundColor
            .edgesIgnoringSafeArea(.all)
            .animation(
                viewModel.animation,
                value: viewModel.backgroundColor
            )
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(false)
            .onAppear {
                viewModel.startTracking()
            }
            .onDisappear {
                viewModel.stopTracking()
            }
    }
}
