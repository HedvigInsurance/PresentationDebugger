//
//  StoreList.swift
//  StoreList
//
//  Created by Sam Pettersson on 2021-07-18.
//

import Foundation
import SwiftUI

struct StoreList: View {
    let service = HTTPService()
    @State var container: StoreDebuggerContainer? = nil
    
    var body: some View {
        NavigationView {
            List {
                if let container = container {
                    ForEach(container.stores, id: \.name) { store in
                        NavigationLink {
                            StoreView(representation: store)
                        } label: {
                            HStack {
                                Text(store.name)
                            }
                        }
                    }
                }
            }.listStyle(.inset).onAppear {
                service.fetchStores { container in
                    self.container = container
                }
            }
        }
    }
}
