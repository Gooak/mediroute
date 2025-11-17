//
//  DiagnosisItemView.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//
import SwiftUI

struct DiagnosisItemView: View {
    var item: DiagnosisHistory
    var onNearByHospital: () -> Void
    var onDelete: (DiagnosisHistory) -> Void

    @State private var isExpanded: Bool = false

    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                VStack(alignment: .leading, spacing: 6) {
                    Text("증상: \(item.symptom)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Divider() // 중간 가로줄
                    Text("진단 결과: \(item.diagnosisResult)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    Divider() // 중간 가로줄
                    HStack{
                        Button {
                            onDelete(item)
                        } label: {
                            // 삭제를 나타내는 아이콘 사용
                            Image(systemName: "trash")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        
                        Button {
                            onNearByHospital()
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .trailing) // ← 전체 가로 최대 & 왼쪽 정렬
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            },
            label: {
                Text(item.diagnosisTime, format: Date.FormatStyle(date: .numeric, time: .shortened))
                    .font(.headline)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading) // ← 레이블도 가로 최대 & 왼쪽 정렬
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
            }
        )
    }
}
