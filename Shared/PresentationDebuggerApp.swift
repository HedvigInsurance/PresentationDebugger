//
//  PresentationDebuggerApp.swift
//  Shared
//
//  Created by Sam Pettersson on 2021-07-18.
//

import SwiftUI

@main
struct PresentationDebuggerApp: App {
    let service = WebSocketService()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Sidebar()
                EmptyView()
            }
        }
    }
}
