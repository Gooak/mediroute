//
//  CostomButton.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//

import SwiftUI

struct CustomButton: View {
    let title : String
    let loadingText : String
    
    @Binding var isLoading : Bool
    
    let action : () -> Void
    
    var body : some View {
        // 제출 버튼
        Button(action: {
            action()
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                Text(isLoading ? loadingText : title)
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isLoading ? Color.gray.opacity(0.4) : Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .disabled(isLoading)
        .accessibilityLabel("입력 커스텀 버튼")
    }
}

