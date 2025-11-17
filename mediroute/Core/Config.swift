//
//  Config.swift
//  mediroute
//
//  Created by 황진우 on 11/15/25.
//

import Foundation

enum Config {
    static var aiBaseURL : String = "https://generativelanguage.googleapis.com/v1beta/models/"
    static var aiModelName : String = "gemini-2.5-flash"
    
    static var openDataURL: String = "https://apis.data.go.kr/B552657/HsptlAsembySearchService/getHsptlMdcncListInfoInqire"
    
    static var geminiApiKey: String {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Info.plist 파일을 찾을 수 없습니다.")
        }
        
        guard let apiKey = infoDictionary["GeminiApiKey"] as? String else {
            fatalError("Info.plist에 'GeminiAPIKey'가 설정되지 않았거나 문자열이 아닙니다. $(GEMINI_API_KEY) 값을 확인하세요.")
        }
        
        
        if apiKey.isEmpty || apiKey == "여기에_발급받은_API_키를_붙여넣으세요" {
            fatalError("API 키가 'keys.xcconfig' 파일에 제대로 입력되지 않았습니다. 가이드를 다시 확인하세요.")
        }
        
        return apiKey
    }
    
    static var openDataApiKey: String {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Info.plist 파일을 찾을 수 없습니다.")
        }
        
        guard let apiKey = infoDictionary["OpenDataApiKey"] as? String else {
            fatalError("Info.plist에 'GeminiAPIKey'가 설정되지 않았거나 문자열이 아닙니다. $(OPEN_DATA_API_KEY) 값을 확인하세요.")
        }
        
        
        if apiKey.isEmpty || apiKey == "여기에_발급받은_API_키를_붙여넣으세요" {
            fatalError("API 키가 'keys.xcconfig' 파일에 제대로 입력되지 않았습니다. 가이드를 다시 확인하세요.")
        }
        
        return apiKey
    }
    
    static let departments: [String : String] = [
        "D001": "내과",
        "D002": "소아청소년과",
        "D003": "신경과",
        "D004": "정신건강의학과",
        "D005": "피부과",
        "D006": "외과",
        "D007": "흉부외과",
        "D008": "정형외과",
        "D009": "신경외과",
        "D010": "성형외과",
        "D011": "산부인과",
        "D012": "안과",
        "D013": "이비인후과",
        "D014": "비뇨기과",
        "D016": "재활의학과",
        "D017": "마취통증의학과",
        "D018": "영상의학과",
        "D019": "치료방사선과",
        "D020": "임상병리과",
        "D021": "해부병리과",
        "D022": "가정의학과",
        "D023": "핵의학과",
        "D024": "응급의학과",
        "D026": "치과",
        "D034": "구강악안면외과"
    ]
    
    static func prompt(symptom : String) -> String {
        return """
        [역할]: 당신은 사용자의 증상을 분석하고 전문적인 정보를 제공하는 AI 의료 상담 도우미입니다.
        [제한]: 모든 답변은 500자 이내의 한국어로 작성해야 하며, 아래 [진료과목 목록] 내에서 단 하나의 최종 추천 과목만 선택해야 합니다.

        ---

        [진료과목 목록]: \(Config.departments.map { "\($0.value)" }.joined(separator: ", "))

        ---

        [사용자 증상]: \(symptom)

        [답변 구조]: 다음 구조에 맞춰 답변을 작성하세요.

        💡 증상 분석 결과
        사용자가 호소하는 증상에 대한 간결한 요약 및 해석.
        예상되는 주요 질환 또는 가능성이 높은 원인 3~4가지 제시.

        🧑‍⚕️ 최종 추천 진료과목
        추천 과목명: [선택한 과목명]
        추천 사유: 추천하는 이유를 1~3문장으로 설명.
        """
    }
}
