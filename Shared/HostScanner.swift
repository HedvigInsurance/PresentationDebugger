//
//  HostScanner.swift
//  PresentationDebugger
//
//  Created by Sam Pettersson on 2021-07-27.
//

import Foundation
import SwiftUI

struct HostScanner: View {
    @EnvironmentObject var settings: Settings
    @State var hosts: [String] = []
    @State var services: [HTTPService] = []
    
    func findHosts() {
        let theOutput = Pipe()

        func shell(Path: String, args: String...) -> Int32 {
           let task = Process()
           task.launchPath = Path
           task.arguments = args
           task.standardOutput = theOutput
           task.standardError = theOutput

           task.launch()
           task.waitUntilExit()

           return task.terminationStatus
        }
        
        let _ = shell(Path: "/usr/sbin/arp", args: "-a")

        let theTaskData = theOutput.fileHandleForReading.readDataToEndOfFile()
        guard let stringResult = String(data: theTaskData, encoding: .utf8) else {
            return
        }

        let lines = stringResult.split(whereSeparator: \.isNewline).map { substring in
            substring.replacingOccurrences(of: "? (", with: "").replacingOccurrences(of: "\\) at.*", with: "", options: .regularExpression).replacingOccurrences(of: " \\(.*", with: "", options: .regularExpression)
        }
        
        lines.forEach { host in
            let service = HTTPService(host: host)
            services.append(service)
            
            service.fetchStores { stores in
                hosts.append(host)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(hosts, id: \.self) { host in
                Button(host) {
                    settings.httpService = HTTPService(host: host)
                    settings.websocketService = WebSocketService(host: host)
                }
            }
        }.onAppear {
            findHosts()
        }
    }
}
