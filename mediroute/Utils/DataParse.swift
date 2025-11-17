//
//  DataParse.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//

final class DataParse {
    // 추천 과목 명 찾기
    static func getDepartmentCode(aiResponse: String) -> String {
        // 찾고자 하는 시작 구문 정의 -- 나중엔 데 변수로 받아도 될듯
        let startMarker = "추천 과목명:"
        
        // 응답 문자열에서 마커의 위치를 찾음
        guard let startRange = aiResponse.range(of: startMarker) else {
            // 마커를 찾지 못하면 nil 반환
            return ""
        }
        
        // 마커 뒤부터의 문자열을 자름
        let remainingString = String(aiResponse[startRange.upperBound...])
        
        // 다음 줄바꿈 문자의 위치 찾음
        if let endRange = remainingString.firstIndex(of: "\n") {
            // 줄바꿈 문자 전까지만 잘라내어 최종 결과를 만듦
            let department = String(remainingString[..<endRange])
            
            // 공백과 줄바꿈 문자를 정리하고 반환 (예: " 신경과 " -> "신경과")
            return department.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            // 줄바꿈이 없는 경우 (문자열의 마지막 부분인 경우) 전체를 정리하여 반환
            return remainingString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
