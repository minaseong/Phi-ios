//
//  UserResponseDTO.swift
//  Citizen_Alerts
//
//  Created by Mina on 11/19/25.
//

// Models/UserResponseDTO.swift
import Foundation

struct UserResponseDTO: Codable {
    let userId: Int64
    let nickname: String?
    let name: String?
    let email: String
    let credScore: Int?
    let userScore: Int?
    let dob: String?
    let gender: String?
    let lastLocation: String?
    let userCreatedAt: String?
}
