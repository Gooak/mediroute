//
//  GeminiRepository.swift
//  mediroute
//
//  Created by 황진우 on 11/15/25.
//

protocol GeminiRepository {
    func getDiagnosis(symptom: String) async throws -> String
}
