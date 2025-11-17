//
//  SymptomView.swift
//  mediroute
//
//  Created by 황진우 on 11/14/25.
//

import SwiftUI
import SwiftData

struct SymptomInputView: View {
    @StateObject private var viewModel = SymptomViewModel()

    @Environment(\.modelContext) private var modelContext
    @Query private var diagnosisHistory: [DiagnosisHistory]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("증상을 입력해 주세요")
                        .font(.title2)
                        .bold()
                    Text("예: 어제부터 배가 계속 아파요. 통증이 순간적으로 심해집니다.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading).padding()
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))
                        .shadow(color: Color.black.opacity(0.02), radius: 2, x: 0, y: 1)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.white)))
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    
                    TextEditor(text: $viewModel.symptomText)
                        .padding(8)
                        .frame(minHeight: 140)
                        .accessibilityLabel("증상 입력란")
                        .disableAutocorrection(false)
                        .scrollContentBackground(.hidden)
                        .cornerRadius(12)
                    
                    if viewModel.symptomText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text("증상(증세/언제부터/통증 위치 등)을 자세히 적어주세요...")
                            .foregroundColor(.secondary)
                            .padding(EdgeInsets(top: 14, leading: 14, bottom: 0, trailing: 14))
                            .allowsHitTesting(false)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Spacer()
                    Text("\(viewModel.symptomText.count) / \(viewModel.maxLength)")
                        .font(.caption)
                        .foregroundColor(viewModel.symptomText.count > viewModel.maxLength ? .red : .secondary)
                        .padding(.trailing, 22)
                }
                
                if let err = viewModel.errorMessage {
                    Text(err)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                CustomStateButton(title : "AI에게 물어보기", loadingText : "분석중...", isSubmitting : $viewModel.isSubmitting, isValid: viewModel.isValid,
                    action : {
                        hideKeyboard()
                        Task {
                            viewModel.submitSymptom {
                                addItem()
                            }
                        }
                    }
                )
                
                Spacer()
                
            }
            .padding(.top, )
            .navigationTitle("AI 간단 진단")
            .navigationDestination(isPresented: $viewModel.shouldShowResult) {
                if let result = viewModel.diagnosisResult {
                    DiagnosisResultView(fullResultText: result)
                }
            }
        }
    }
    
    private func addItem() {
        guard let result = viewModel.diagnosisResult else { return }
        
        withAnimation {
            let newItem = DiagnosisHistory(
                diagnosisTime: Date(),
                symptom: viewModel.symptomText,
                diagnosisResult: result
            )
            modelContext.insert(newItem)
            try? modelContext.save()
        }
    }
}
