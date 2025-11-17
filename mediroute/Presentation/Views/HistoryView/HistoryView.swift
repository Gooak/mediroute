//
//  HistoryView.swift
//  mediroute
//
//  Created by 황진우 on 11/15/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var diagnosisHistory: [DiagnosisHistory]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(diagnosisHistory.reversed()) { item in
                    DiagnosisItemView(item: item, onDelete: deleteItem)
                }
            }
            .padding(.top, 10)
            .padding(.horizontal)
        }
    }
    private func addItem() {
        withAnimation {
            let newItem = DiagnosisHistory(
                diagnosisTime: Date(),
                symptom: "",
                diagnosisResult: ""
            )
            modelContext.insert(newItem)
            try? modelContext.save()
        }
    }

    private func deleteItem(_ item: DiagnosisHistory) {
        withAnimation {
            modelContext.delete(item)
            try? modelContext.save()
        }
    }

    private func checkNearbyHospitals() {
        // 주위 병원 조회 기능
    }
}


