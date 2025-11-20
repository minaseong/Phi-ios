//
//  AuthAPI.swift
//  Citizen_Alerts
//
//  Created by Mina on 11/19/25.
//

// Networking/AuthAPI.swift
import Foundation

enum APIError: Error {
    case invalidURL
    case invalidStatusCode(Int)
    case decodingFailed
}

struct AuthAPI {

    // For simulator: use your machine IP if backend is not on device
    static let baseURL = "http://localhost:8080" // or "http://192.168.x.x:8080"

    static func login(email: String, password: String) async throws -> UserResponseDTO {
        guard let url = URL(string: "\(baseURL)/api/users/v1/login") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = LoginRequestDTO(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidStatusCode(-1)
        }

        switch httpResponse.statusCode {
        case 200:
            do {
                return try JSONDecoder().decode(UserResponseDTO.self, from: data)
            } catch {
                throw APIError.decodingFailed
            }
        case 401:
            throw APIError.invalidStatusCode(401)
        default:
            throw APIError.invalidStatusCode(httpResponse.statusCode)
        }
    }
}
