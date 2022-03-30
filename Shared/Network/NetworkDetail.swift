//
//  NetworkDetail.swift
//  PresentationDebugger (iOS)
//
//  Created by Sam Pettersson on 2021-07-28.
//

import Foundation
import SwiftUI

typealias JSONDictionary = [String:Any]

struct NetworkDetail: View {
    var dictionary: [String:Any]
    
    @State
    var focused: JSONDictionary
    
    @State
    var previous = [JSONDictionary]()
    
    var body: some View {
        List {
            if !previous.isEmpty {
                Section {
                    Button("Back") {
                        if let previous = previous.popLast() {
                            focused = previous
                        }
                    }
                }
            }
            
            Section {
                ForEach(focused.keys.sorted() , id: \.self) { key in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(key)
                                .foregroundColor(.black)
                        }.padding(5).background(.blue)
                        
                        if let value = focused[key] as? String {
                            HStack {
                                Text(value)
                                    .foregroundColor(.black)
                            }
                            .padding(5).background(.green)
                            .onTapGesture {
                                if let newDictionary = dictionary[key] as? JSONDictionary {
                                    updateFocus(for: newDictionary)
                                }
                            }
                        } else if let value = focused[key] as? [JSONDictionary] {
                            NetworkDetails(dictionaries: value) { newDictionary in
                                updateFocus(for: newDictionary)
                            }
                        } else if let newDictionary = focused[key] as? [String:Any] {
                            HStack {
                                Text(newDictionary.debugDescription)
                                    .foregroundColor(.black)
                            }
                            .padding(5).background(.green)
                            .onTapGesture {
                                updateFocus(for: newDictionary)
                            }
                        }
                    }.padding(5)
                }
            }
        }
    }
    
    func updateFocus(for dict: JSONDictionary) {
        let current = focused
        focused = dict
        previous.append(current)
    }
}


struct NetworkDetails: View {
    var dictionaries: [JSONDictionary]
    
    var onTap: (JSONDictionary) -> Void
    
    var body: some View {
        HStack {
            ForEach(dictionaries.indices) { index in
                HStack {
                    Text(String(index))
                        .foregroundColor(.black)
                }.padding(5).background(.red)
                    .onTapGesture {
                        onTap(dictionaries[index])
                    }
            }
        }
    }
}

extension JSONDictionary: Identifiable {
    public var id: String {
        return keys.joined(separator: ".")
    }
}
