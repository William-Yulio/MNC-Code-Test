//
//  UserModel.swift
//  UserApp
//
//  Created by William Yulio on 06/06/23.
//

import Foundation

// MARK: - User
struct User: Codable {
    let data: [Datum]
    let messages: String
    let status, total: Int

    enum CodingKeys: String, CodingKey {
        case data = "DATA"
        case messages = "MESSAGES"
        case status = "STATUS"
        case total = "TOTAL"
    }
}

// MARK: - Datum
struct Datum: Codable {
    let dob, firstName, lastName: String
    let memberID: Int
    
    enum CodingKeys: String, CodingKey {
        case dob
        case firstName = "first_name"
        case lastName = "last_name"
        case memberID = "member_id"
    }
}

struct CalculatedAgeData{
    var dob, firstName, lastName: String
    var memberID, age: Int
    
    init(dob: String, firstName: String, lastName: String, memberID: Int, age: Int) {
        self.dob = dob
        self.firstName = firstName
        self.lastName = lastName
        self.memberID = memberID
        self.age = age
    }

}

