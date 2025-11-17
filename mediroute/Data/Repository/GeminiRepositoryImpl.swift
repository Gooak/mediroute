//
//  GeminiRepositoryImpl.swift
//  mediroute
//
//  Created by 황진우 on 11/15/25.
//

final class GeminiRepositoryImpl: GeminiRepository {

    private let dataSource: GeminiRemoteDataSource

    init(dataSource: GeminiRemoteDataSource) {
        self.dataSource = dataSource
    }

    func getDiagnosis(symptom: String) async throws -> String {
        let result = try await dataSource.analyze(symptom: symptom)
        return result
    }
}
