//
//  NetworkHistoryList.swift
//  PresentationDebugger (iOS)
//
//  Created by Sam Pettersson on 2021-07-28.
//

import Foundation
import SwiftUI

struct NetworkHistoryList: View {
    @EnvironmentObject var settings: Settings
    @State var container: NetworkHistoryContainer? = nil
    
    var body: some View {
        NavigationView {
            List {
                if let container = container {
                    ForEach(container.entries) { entry in
                        NavigationLink {
                            NetworkDetail(dictionary: entry.dictionary, focused: entry.dictionary)
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(Date(timeIntervalSince1970: entry.timestamp).formatted()).foregroundColor(Color.black)
                                }.padding(5).background(entry.responseCode == 200 ? Color.green : Color.red).cornerRadius(3, antialiased: true)
                                HStack {
                                    Text(entry.url)
                                }
                            }.padding(5)
                        }
                    }
                }
            }.listStyle(.inset).onAppear {
                settings.httpService.networkHistory { container in
                    self.container = container
                }
            }.frame(minWidth: 500)
        }
    }
}

extension NetworkEntry {
    var dictionary: [String:Any] {
        guard let data = response.data(using: .utf8), let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return [:]}
        
        return dictionary
    }
}
