//
//  SendActionView.swift
//  SendActionView
//
//  Created by Sam Pettersson on 2021-07-18.
//

import Foundation
import SwiftUI

struct ActionInput: View {
    let input: StoreDebuggerRepresentationActionInput
        
    let onValue: (_ values: ([String: Any]?, Any?)) -> Void
    
    @State var concreteValueString = ""
    @State var nestedValueHolder: [String: Any] = [:]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if input.inputs.isEmpty {
                TextField(input.name, text: $concreteValueString).textFieldStyle(.roundedBorder).foregroundColor(.gray).onChange(of: concreteValueString) { newValue in
                    switch input.type {
                    case "Int":
                        onValue((nil, Int(concreteValueString)!))
                    case "String":
                        onValue((nil, concreteValueString))
                    default:
                        break
                    }
                }
            } else {
                Text(input.name).font(.subheadline).padding(.leading, 15)
                ForEach(input.inputs, id: \.name) { input in
                    ActionInput(input: input) { value in
                        let (nestedValue, concreteValue) = value
                        nestedValueHolder[input.name] = nestedValue ?? concreteValue
                        onValue((nestedValueHolder, nil))
                    }
                }
            }
        }
    }
}

struct SendActionView: View {
    let representation: StoreDebuggerRepresentation
    let action: StoreDebuggerRepresentationAction
    
    let onSubmit: (_ values: [String: Any]) -> Void
    
    @State var valueHolder: [String: Any] = [:]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Text(action.name).font(.headline).padding(.bottom, 15)
            ForEach(action.inputs, id: \.name) { input in
                ActionInput(input: input) { value in
                    let (nestedValue, concreteValue) = value
                    valueHolder[input.name] = nestedValue ?? concreteValue
                }
            }
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
                Button {
                    presentationMode.wrappedValue.dismiss()
                    onSubmit(valueHolder)
                } label: {
                    Text("Send")
                }
            }.padding(.top, 15)
        }.padding(30).frame(width: 400)
    }
}
