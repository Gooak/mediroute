//
//  NetworkError.swift
//  mediroute
//
//  Created by 황진우 on 11/15/25.
//

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse(Int, String) // HTTP 상태 코드와 메시지
    case decodingError(Error)
    case unknown
}

