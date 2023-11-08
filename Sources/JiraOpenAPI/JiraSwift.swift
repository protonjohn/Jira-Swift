//
//  JiraSwift.swift
//  
//
//  Created by John Biggs on 08.11.23.
//

import Foundation
import OpenAPIURLSession

extension Client {
    public init(serverURL: URL) {
        self.init(serverURL: serverURL, transport: URLSessionTransport())
    }
}
