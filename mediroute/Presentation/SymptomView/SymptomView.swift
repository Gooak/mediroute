//
//  SymptomView.swift
//  mediroute
//
//  Created by 황진우 on 11/14/25.
//

import SwiftUI

struct SymptomInputView: View {
    @StateObject private var vm = SymptomViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // 타이틀 / 설명
                VStack(alignment: .leading, spacing: 16) {
                    Text("증상을 입력해 주세요")
                        .font(.title2)
                        .bold()
                    Text("예: 어제부터 배가 계속 아파요. 통증이 순간적으로 심해집니다.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading).padding()

                // TextEditor (멀티라인)
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))
                        .shadow(color: Color.black.opacity(0.02), radius: 2, x: 0, y: 1)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.white)))
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                
                    TextEditor(text: $vm.symptomText)
                        .padding(8)
                        .frame(minHeight: 140)
                        .accessibilityLabel("증상 입력란")
                        .disableAutocorrection(false)
                        .scrollContentBackground(.hidden)
                        .cornerRadius(12)
                    
                    // Placeholder
                    if vm.symptomText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text("증상(증세/언제부터/통증 위치 등)을 자세히 적어주세요...")
                            .foregroundColor(.secondary)
                            .padding(EdgeInsets(top: 14, leading: 14, bottom: 0, trailing: 14))
                            .allowsHitTesting(false)
                    }
                }
                .padding(.horizontal)

                // 글자수와 최대치
                HStack {
                    Spacer()
                    Text("\(vm.symptomText.count) / \(vm.maxLength)")
                        .font(.caption)
                        .foregroundColor(vm.symptomText.count > vm.maxLength ? .red : .secondary)
                        .padding(.trailing, 22)
                }

                // 에러 메시지
                if let err = vm.errorMessage {
                    Text(err)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer()
                
                // 제출 버튼
                Button(action: {
                    hideKeyboard()
                    vm.submitSymptom { result in
                        switch result {
                        case .success(let response):
                            // 실제 앱에서는 AI 응답(예: 진료과 코드)을 받아 다음 화면으로 이동
                            print("AI 응답:", response)
                        case .failure(let error):
                            vm.errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    HStack {
                        if vm.isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        Text(vm.isSubmitting ? "분석중..." : "AI에게 물어보기")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(vm.isValid ? Color.accentColor : Color.gray.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .disabled(!vm.isValid || vm.isSubmitting)
                .accessibilityLabel("AI에게 물어보기 버튼")
            }
            .padding(.top, )
            .navigationTitle("병원찾아줘")
            
        }
    }
}

struct SymptomInputView_Previews: PreviewProvider {
    static var previews: some View {
        SymptomInputView()
            .preferredColorScheme(.light)

        SymptomInputView()
            .preferredColorScheme(.dark)
    }
}
