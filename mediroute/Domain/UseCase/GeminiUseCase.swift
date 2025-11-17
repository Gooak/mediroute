//
//  GeminiUsecase.swift
//  mediroute
//
//  Created by 황진우 on 11/15/25.
//

final class GeminiUseCase {
        private let repository: GeminiRepository
    
    init(repository: GeminiRepository) {
        self.repository = repository
    }
    
    func getDiagnosis(symptom: String) async throws -> String {
        
        do {
            let result = try await repository.getDiagnosis(symptom: symptom)
            return result
        } catch {
            throw error
        }
    }
}
