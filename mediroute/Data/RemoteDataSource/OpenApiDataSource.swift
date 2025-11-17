//
//  OpenApiDataSource.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//

import Foundation

protocol OpenApiDataSource {
    func getNearByHospital(administrativeArea: String, subLocality : String, departmentName : String) async throws -> Data
}


final class OpenApiDataSourceImpl : OpenApiDataSource{
    
    private let apiKey = Config.openDataApiKey // 2번 파일에서 API 키 가져오기
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func getNearByHospital(administrativeArea: String, subLocality : String, departmentName : String) async throws -> Data {
        
        let baseURL = Config.openDataURL
        
        // 요청 파라미터 딕셔너리 정의 (예시 데이터)
        let parameters: [String: String] = [
            "serviceKey": apiKey,
            "Q0": administrativeArea,      // 주소 (시도)
            "Q1": subLocality,          // 주소 (시군구)
            "QZ": "C",             // 기관별 (B:병원, C:의원)
            "QD": Config.departments.first { $0.value == departmentName }?.key ?? "", // 진료과목별 (D001:내과)
            "QT": "1~7",             // 진료요일 월~일요일(1~7), 공휴일(8)
            "QN": "",        // 기관명 (병원 이름)
            "ORD": "",         // 순서 (기관명 기준)
            "pageNo": "1",         // 페이지 번호
            "numOfRows": "100"      // 목록 건수
        ]
        
        // URLComponents를 사용하여 쿼리 파라미터 생성 및 인코딩 처리
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        // 쿼리 아이템 배열 생성
        urlComponents.queryItems = parameters.map { (key, value) in
            return URLQueryItem(name: key, value: value)
        }
        
        // URL 객체 생성 확인
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        // URLRequest 설정
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // URLSession을 사용하여 비동기 요청 및 응답 대기
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // HTTP 상태 코드 확인
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}

