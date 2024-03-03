//
//  TravelCoachApp.swift
//  TravelCoach
//
//  Created by Cantek Batur on 2024-01-25.
//

import SwiftData
import SwiftUI

@main
struct TravelCoachApp: App {
    @State private var isShowingLaunchView = true
    
    var body: some Scene {
        WindowGroup {
            if isShowingLaunchView {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
                            isShowingLaunchView = false
                        }
                    }
            } else {
                MainTabbedView()
            }
        }
        .modelContainer(for: Destination.self)
    }
}
