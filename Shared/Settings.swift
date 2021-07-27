//
//  Settings.swift
//  PresentationDebugger
//
//  Created by Sam Pettersson on 2021-07-27.
//

import Foundation

class Settings: ObservableObject {
    @Published var httpService: HTTPService
    @Published var websocketService: WebSocketService
    
    init() {
        httpService = HTTPService(host: "localhost")
        websocketService = WebSocketService(host: "localhost")
    }
}
