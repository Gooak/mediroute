//
//  CostomButton.swift
//  mediroute
//
//  Created by 황진우 on 11/15/25.
//

import SwiftUI

struct CostomButton: View {
    let title : String
    let loadingText : String
    
    @Binding var isSubmitting : Bool
    
    var isValid : Bool
    
    let action : () -> Void
    
    var body : some View {
        // 제출 버튼
        Button(action: {
            action()
        }) {
            HStack {
                if isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                Text(isSubmitting ? loadingText : title)
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isValid ? Color.accentColor : Color.gray.opacity(0.4))
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .disabled(!isValid || isSubmitting)
        .accessibilityLabel("입력 커스텀 버튼")
    }
}
