//
//  DiagnosisResultView.swift
//  mediroute
//
//  Created by 황진우 on 11/15/25.
//

import SwiftUI
import Combine

struct DiagnosisResultView: View {
    
    @StateObject private var viewModel = DiagnosisResultViewModel()
    @State private var isActive: Bool = true
    @State var draw: Bool = false
    @State private var selectedHospital: Hospital? = nil
    
    let fullResultText: String // 답변 전체 텍스트
    let departmentName: String // 답변 병원 과
    
    @State private var displayedText: String = "" // 화면에 표시될 텍스트
    @State private var currentIndex: Int = 0       // 현재 타이핑 중인 인덱스
    private let typingInterval: TimeInterval = 0.03 // 타이핑 속도 (0.03초)
    
    private let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect() //타이머 실행
    
    @State private var cancellable: AnyCancellable? //타이머 구독 객체
    
    var body: some View {
        VStack(spacing: 0) {
        ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(displayedText)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            CustomButton(
                title: "근처 병원 찾기",
                loadingText: "병원 찾는중..",
                isLoading: $viewModel.isLoading,
                action: {
                    Task {
                        await viewModel.findHospital(fullResultText: fullResultText, departmentName : departmentName)
                    }
                }
            )
            .padding()
        }
        .onAppear {
            // 뷰가 나타날 때 타이핑 시작
            startTyping()
        }
        .navigationTitle("AI 진단 결과")
        .navigationDestination(isPresented: $viewModel.shouldShowResult) {
            if let longitude = viewModel.longitude,
               let latitude = viewModel.latitude,
               let hospitalListResult = viewModel.hospitalListResult  {
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
    
    //타이핑 로직
    func startTyping() {
        cancellable?.cancel()
        
        cancellable = timer
            .sink { _ in
                // 이미 모두 표시되었으면 타이머 구독을 중지
                guard currentIndex < fullResultText.count else {
                    self.cancellable?.cancel()
                    return
                }

                let nextIndex = fullResultText.index(fullResultText.startIndex, offsetBy: currentIndex)
                displayedText.append(fullResultText[nextIndex])
                currentIndex += 1
            }
    }
}
