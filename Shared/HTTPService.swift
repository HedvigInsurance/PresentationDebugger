//
//  HTTPService.swift
//  HTTPService
//
//  Created by Sam Pettersson on 2021-07-18.
//

import Foundation

struct StoreDebuggerRepresentationActionInput: Codable, Hashable {
    let type: String
    let name: String
    let inputs: [StoreDebuggerRepresentationActionInput]
}

struct StoreDebuggerRepresentationAction: Codable, Identifiable, Hashable {
    var id: String {
        name
    }
    
    let name: String
    let inputs: [StoreDebuggerRepresentationActionInput]
}

struct StoreDebuggerRepresentation: Codable, Hashable {
    let name: String
    let actions: [StoreDebuggerRepresentationAction]
}

struct StoreDebuggerContainer: Codable {
    var stores: [StoreDebuggerRepresentation] = []
}

class HTTPService {
    private let urlSession = URLSession(configuration: .default)
    private let baseURLString: String
    
    init(host: String) {
        self.baseURLString = "http://\(host):3040"
    }
        
    func fetchStores(_ completion: @escaping (StoreDebuggerContainer) -> Void) {
        urlSession.dataTask(with: URLRequest(url: URL(string: "\(baseURLString)/stores")!)) { data, _, _ in
            guard let data = data else {
                return
            }
            if let container = try? JSONDecoder().decode(StoreDebuggerContainer.self, from: data)  {
                completion(container)
            }
        }.resume()
    }
    
    func history(_ completion: @escaping ([String: Any]) -> Void) {
        urlSession.dataTask(with: URLRequest(url: URL(string: "\(baseURLString)/stores")!)) { data, _, _ in
            guard let data = data else {
                return
            }
            
            let history = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            completion(history)
        }.resume()
    }
    
    func sendAction(_ store: String, action: [String: Any]) {
        let json: [String: Any] = [
            "store": store,
            "action": action
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
                    
        var request = URLRequest(url: URL(string: "\(baseURLString)/send")!)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    }
}
