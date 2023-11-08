//
//  Issue.swift
//  JiraSwift
//
//  Created by Bill Gestrich on 10/28/17.
//  Copyright © 2017 Bill Gestrich. All rights reserved.
//

import Foundation

public struct Issue : Codable {
    public var id: String = ""
    public var key: String = ""
    public var urlString: String = ""
    public var fields : Fields
    
    enum CodingKeys : String, CodingKey {
        case id
        case key
        case urlString = "self"
        case fields
    }

    public struct Fields : Codable {
        public let epic: String?
        public var summary: String
        public var fixVersions: [FixVersion]?
        public let assignee: Assignee?
        public var description : String?
        public let status: IssueStatus
        public let created: Date

        private let extraFields: [String: CodableCollection]

        public func customField(name: String) -> Any? {
            extraFields[name]?.value
        }

        enum CodingKeys : String, CaseIterable, CodingKey {
            case epic = "customfield_10017"
            case summary
            case fixVersions
            case assignee
            case description
            case status
            case created //"created": "2019-08-28T09:42:49.091-0500",
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Issue.Fields.CodingKeys.self)
            self.epic = try container.decodeIfPresent(String.self, forKey: Issue.Fields.CodingKeys.epic)
            self.summary = try container.decode(String.self, forKey: Issue.Fields.CodingKeys.summary)
            self.fixVersions = try container.decodeIfPresent([Issue.FixVersion].self, forKey: Issue.Fields.CodingKeys.fixVersions)
            self.assignee = try container.decodeIfPresent(Assignee.self, forKey: Issue.Fields.CodingKeys.assignee)
            self.description = try container.decodeIfPresent(String.self, forKey: Issue.Fields.CodingKeys.description)
            self.status = try container.decode(Issue.IssueStatus.self, forKey: Issue.Fields.CodingKeys.status)
            self.created = try container.decode(Date.self, forKey: Issue.Fields.CodingKeys.created)

            let collection = try CodableCollection(from: decoder)
            guard case .dictionary(var extraFields) = collection else {
                throw DecodingError.dataCorrupted(.init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Couldn't decode extra fields"
                ))
            }

            // Strip values that we already explicitly decoded above
            for key in CodingKeys.allCases {
                extraFields.removeValue(forKey: key.rawValue)
            }

            self.extraFields = extraFields
        }
    }
    
    public struct FixVersion : Codable {
        public let description : String?
        public let name : String
        enum CodingKeys : String, CodingKey {
            case description
            case name
        }
    }
    
    public struct IssueStatus : Codable {
        public let description : String?
        public let name : String
    }
    
}



