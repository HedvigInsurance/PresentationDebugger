//
//  NetworkDetail.swift
//  PresentationDebugger (iOS)
//
//  Created by Sam Pettersson on 2021-07-28.
//

import Foundation
import SwiftUI

struct NetworkDetail: View {
    var entry: NetworkEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(entry.url)
                Text(entry.prettyPrintedResponse)
            }.padding(20)
        }
    }
}
