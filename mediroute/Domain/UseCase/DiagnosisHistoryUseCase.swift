//
//  DiagnosisHistoryUsecase.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//
import Foundation
import SwiftData

@MainActor
final class DiagnosisHistoryUseCase {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // 추가
    func addDiagnosis(symptom: String, result: String) {
        let history = DiagnosisHistory(
            diagnosisTime: Date(),
            symptom: symptom,
            diagnosisResult: result
        )
        modelContext.insert(history)
        try? modelContext.save()
    }

    // 삭제
    func removeDiagnosis(_ history: DiagnosisHistory) {
        modelContext.delete(history)
        try? modelContext.save()
    }
}
