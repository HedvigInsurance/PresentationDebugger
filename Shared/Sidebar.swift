//
//  Sidebar.swift
//  Sidebar
//
//  Created by Sam Pettersson on 2021-07-18.
//

import Foundation
import SwiftUI

struct Sidebar: View {
    var body: some View {
        List {
            Text("State").foregroundColor(.gray)
            NavigationLink {
                StoreList()
            } label: {
                HStack {
                    Image(systemName: "timer")
                    Text("Stores")
                }
            }
            NavigationLink {
                StoreList()
            } label: {
                HStack {
                    Image(systemName: "timer")
                    Text("History")
                }
            }
            NavigationLink {
                NetworkHistoryList()
            } label: {
                HStack {
                    Image(systemName: "network")
                    Text("Network History")
                }
            }
            NavigationLink {
                HostScanner()
            } label: {
                HStack {
                    Image(systemName: "network")
                    Text("Hosts")
                }
            }
        }.listStyle(.sidebar).navigationTitle("Presentation Debugger")
    }
}
