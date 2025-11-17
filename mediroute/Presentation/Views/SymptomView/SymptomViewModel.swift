//
//  SymptomViewModel.swift
//  mediroute
//
//  Created by 황진우 on 11/14/25.
//

import SwiftUI

final class SymptomViewModel: ObservableObject {
    @Published var symptomText: String = "" {
        didSet {
            if symptomText.count > maxLength {
                symptomText = String(symptomText.prefix(maxLength))
            }
        }
    }
    @Published var isSubmitting: Bool = false // 입력 완료
    @Published var errorMessage: String? = nil // 에러 메세지
    
    @Published var diagnosisResult: String? // 진단 결과
    @Published var shouldShowResult = false // 링크 활성화
    
    let maxLength: Int = 1000
    
    var isValid: Bool {
        let trimmed = symptomText.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty
    }
    
    private let useCase: GeminiUseCase
    
    init(useCase: GeminiUseCase = DIContainer.Di.geminiUseCase) {
        self.useCase = useCase
    }


    // 제출 함수 (여기에 AI 호출 또는 네트워크 로직 작성)
    func submitSymptom(completionHandler: @escaping () -> Void) {
        guard isValid else { return }

        isSubmitting = true
        errorMessage = nil

        Task {
            do {
                let result = try await useCase.getDiagnosis(symptom: symptomText)

                await MainActor.run {
                    diagnosisResult = result
                    isSubmitting = false
                    shouldShowResult = true
                    completionHandler()
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    errorMessage = "요청 중 에러가 발생하였습니다. 다시 시도해 주세요."
                }
            }
        }
    }
}
