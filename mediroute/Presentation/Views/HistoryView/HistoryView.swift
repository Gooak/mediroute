//
//  HistoryView.swift
//  mediroute
//
//  Created by 황진우 on 11/15/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State var draw: Bool = false
    @State private var selectedHospital: Hospital? = nil
    
    @Environment(\.modelContext) private var modelContext
    @Query private var diagnosisHistory: [DiagnosisHistory]

    var body: some View {
        NavigationStack {
            if diagnosisHistory.isEmpty {
                VStack {
                    Text("진단 기록이 없습니다.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // 화면 중앙 정렬을 위해
                        .padding(.top, 50) // 상단에서 적당히 떨어지도록 패딩 추가
                }
                .navigationTitle("진단 기록")
            } else {
                ScrollView {
                VStack(spacing: 12) {
                    ForEach(diagnosisHistory.reversed()) { item in
                        DiagnosisItemView(
                            item: item,
                            onNearByHospital: {
                                Task {
                                    // findHospital 호출 로직은 그대로 유지
                                    await viewModel.findHospital(
                                        fullResultText: item.diagnosisResult,
                                        departmentName: item.departmentsName
                                    )
                                }
                            },
                            onDelete: deleteItem
                        )
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal)
                    
                }.padding(.top, )
                .navigationTitle("진단 기록")
                .navigationDestination(isPresented: $viewModel.shouldShowResult) {
                    if let longitude = viewModel.longitude,
                       let latitude = viewModel.latitude,
                       let hospitalListResult = viewModel.hospitalListResult {
                        KakaoMapView(draw: $draw, initialLongitude: longitude, initialLatitude: latitude, initialHospitalListResult: hospitalListResult, selectedHospitalInfo: $selectedHospital)
                            .onAppear(perform: {
                                self.draw = true
                            }).onDisappear(perform: {
                                self.draw = false
                            }).frame(maxWidth: .infinity, maxHeight: .infinity)
                            .sheet(item: $selectedHospital) { hospital in
                                HospitalDetailDialog(hospital: hospital)
                                .presentationDetents([.medium, .fraction(0.3), .height(350)])
                            }
                    }
                }
            }
        }
    }
    
    private func deleteItem(_ item: DiagnosisHistory) {
        withAnimation {
            modelContext.delete(item)
            try? modelContext.save()
        }
    }
}


