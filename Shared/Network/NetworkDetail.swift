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
    
    var body: some View {
        List {
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
                                    focused = newDictionary
                                }
                            }
                        } else if let value = focused[key] as? [JSONDictionary] {
                            NetworkDetails(dictionaries: value)
                        } else if let value = focused[key] as? [String:Any] {
                            HStack {
                                Text(value.debugDescription)
                                    .foregroundColor(.black)
                            }
                            .padding(5).background(.green)
                            .onTapGesture {
                                focused = value
                            }
                        }
                    }.padding(5)
                }
            }
        }
    }
}


struct NetworkDetails: View {
    var dictionaries: [JSONDictionary]
    
    var body: some View {
        VStack {
            ForEach(dictionaries) { dict in
                
            }
        }
    }
}

extension JSONDictionary: Identifiable {
    public var id: String {
        return keys.joined(separator: ".")
    }
}
