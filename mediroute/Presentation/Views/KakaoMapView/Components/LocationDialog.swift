//
//  LocationDialog.swift
//  mediroute
//
//  Created by 황진우 on 11/17/25.
//
import SwiftUI

struct HospitalDetailDialog: View {
    // sheet(item:) Modifier를 사용하면, Environment에 dismiss가 자동으로 제공됩니다.
    @Environment(\.dismiss) var dismiss
    let hospital: Hospital
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 병원 이름 (타이틀)
            Text(hospital.hospitalName!)
                .font(.title2)
                .fontWeight(.bold)
            
            // 3. 연락처 및 전화 걸기 버튼
            HStack {
                Image(systemName: "phone.fill")
                Text("전화번호: \(hospital.hospitalTel ?? "정보 없음")")
                
                Spacer()
                
                // ⭐️ 전화 걸기 버튼
                if let tel = hospital.hospitalTel, !tel.isEmpty {
                    Button("전화 걸기") {
                        callNumber(phoneNumber: tel)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            // 4. 주소 및 복사 버튼
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "mappin.circle.fill")
                    Text("주소")
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    // ⭐️ 주소 복사 버튼
                    if let addr = hospital.hospitalAddr, !addr.isEmpty {
                        Button("주소 복사") {
                            copyToClipboard(text: addr)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                Text(hospital.hospitalAddr ?? "주소 정보 없음")
                    .padding(.leading, 25)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func callNumber(phoneNumber: String) {
        let cleanNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        if let url = URL(string: "tel:\(cleanNumber)") {
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("🚨 ERROR: 전화를 걸 수 없는 기기입니다 (시뮬레이터 또는 전화 기능 없음). URL: \(url)")
            }
        } else {
            print("🚨 ERROR: 전화번호 URL 생성 실패.")
        }
    }
    
    // 클립보드 복사 기능
    private func copyToClipboard(text: String) {
        // ⭐️ 클립보드에 텍스트 복사
        UIPasteboard.general.string = text
        // (선택 사항: 복사 성공 알림 추가 가능)
        print("✅ 클립보드에 복사 완료: \(text)")
    }
}
