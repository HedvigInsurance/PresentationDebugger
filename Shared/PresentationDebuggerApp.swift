//
//  PresentationDebuggerApp.swift
//  Shared
//
//  Created by Sam Pettersson on 2021-07-18.
//

import SwiftUI

@main
struct PresentationDebuggerApp: App {
    @StateObject var settings = Settings()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Sidebar().environmentObject(settings)
                EmptyView()
            }
        }
    }
}
