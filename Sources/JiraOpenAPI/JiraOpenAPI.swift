//
//  JiraOpenAPI.swift
//  
//
//  Created by John Biggs on 08.11.23.
//

import Foundation
import JiraOpenAPIClient
import OpenAPIURLSession
import OpenAPIRuntime

public enum JiraOpenAPI {
    public static func client(serverURL: URL, urlSession: URLSession = .shared, middlewares: [ClientMiddleware] = []) -> Client {
        return .init(serverURL: serverURL, transport: URLSessionTransport(configuration: .init(session: urlSession)), middlewares: middlewares)
    }
}
