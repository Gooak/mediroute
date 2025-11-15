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
    @Published var isSubmitting: Bool = false
    @Published var errorMessage: String? = nil
    
    let maxLength: Int = 1000
    
    var isValid: Bool {
        let trimmed = symptomText.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty
    }
    
    init() {
        
    }


    // 제출 함수 (여기에 AI 호출 또는 네트워크 로직 작성)
    func submitSymptom(completion: @escaping (Result<String, Error>) -> Void) {
        guard isValid else {
            completion(.failure(NSError(domain: "SymptomError", code: 1, userInfo: [NSLocalizedDescriptionKey: "증상을 입력해 주세요."])))
            return
        }

        isSubmitting = true
        errorMessage = nil

        // --- 네트워크/AI 호출 예시 (비동기) ---
        // 실제로는 URLSession 또는 OpenAI SDK 호출 등을 여기서 수행.
        // 아래는 예시로 1초 딜레이 후 성공 콜백을 반환.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isSubmitting = false
            // 성공 시: completion(.success("내과"))
            completion(.success("진료과 추천 예시: 내과"))
        }
    }
}
