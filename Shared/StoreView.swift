//
//  StoreView.swift
//  StoreView
//
//  Created by Sam Pettersson on 2021-07-18.
//

import Foundation
import SwiftUI

struct JSONTable: Identifiable, Hashable {
    var id: String { key + value }
    let key: String
    let value: String
    let children: [JSONTable]?
}

struct StoreView: View {
    public init(representation: StoreDebuggerRepresentation) {
        self.representation = representation
        self.selectedAction = representation.actions.first?.name ?? ""
    }
    
    @EnvironmentObject var settings: Settings
    var representation: StoreDebuggerRepresentation
    @State var currentStoreState: [String: Any] = [:]
    
    @State var selectedAction: String
    @State var selectedActionSheet: StoreDebuggerRepresentationAction? = nil

    @State private var selection: JSONTable?
    
    func stateToTable(_ state: [String: Any]) -> [JSONTable] {
        state.map { key, value in
            if let nestedValue = value as? [String: Any] {
                return JSONTable(key: key, value: String(describing: value), children: stateToTable(nestedValue))
            }

            return JSONTable(key: key, value: String(describing: value), children: nil)
        }
    }
    
    var table: JSONTable {
        JSONTable(key: "Store", value: "", children: stateToTable(currentStoreState))
    }
    
    var body: some View {
        Group {
            HStack {
                Text("Key")
                Spacer()
                Text("Value")
            }.padding(10)
            VStack {
                List(selection: $selection) {
                    OutlineGroup(table, children: \.children) { item in
                        HStack {
                            Text("\(item.key)")
                            Spacer()
                            if item.children == nil {
                                Text(item.value)
                            }
                        }
                    }
                }
            }
            VStack(alignment: .leading) {
                Picker("Actions", selection: $selectedAction) {
                    ForEach(representation.actions.map { $0.name }, id: \.self) { action in
                        Text(action).tag(action)
                    }
                }.sheet(item: $selectedActionSheet) {
                    // on dismiss
                } content: { action in
                    SendActionView(representation: representation, action: action) { value in
                        settings.httpService.sendAction(representation.name, action: [
                            action.name: value
                        ])
                    }
                }
                Button("Create") {
                    selectedActionSheet = representation.actions.first(where: { action in
                        action.name == selectedAction
                    })
                }.padding(.top, 20)
            }.padding(20)
        }
        .onAppear {
            settings.websocketService.connect { result in
                if let message = try? result.get() {
                    switch message {
                    case let .string(string):
                        let jsonData = try? JSONSerialization.jsonObject(with: string.data(using: .utf8)!, options: []) as? [String: String]
                        
                        guard jsonData?["name"] == representation.name else {
                            return
                        }
                        
                        guard let stateData = jsonData?["state"]!.data(using: .utf8) else {
                            return
                        }
                        
                        let jsonDataState = try? JSONSerialization.jsonObject(with: stateData, options: []) as? [String: Any]

                        currentStoreState = jsonDataState!
                    default:
                        break
                    }
                }
            }
        }
    }
}
