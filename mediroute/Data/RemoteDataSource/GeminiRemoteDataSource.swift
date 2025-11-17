//
//  GeminiRemoteDataSource.swift
//  mediroute
//
//  Created by 황진우 on 11/15/25.
//

import Foundation

protocol GeminiRemoteDataSource {
    func analyze(symptom: String) async throws -> String
}


final class GeminiRemoteDataSourceImpl : GeminiRemoteDataSource{
    
    private let apiKey = Config.geminiApiKey
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func analyze(symptom : String) async throws -> String {
        
        let urlString = "\(Config.aiBaseURL)\(Config.aiModelName):generateContent"
        
        // URL 생성
        guard var urlComponents = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }
        urlComponents.queryItems = [URLQueryItem(name: "key", value: apiKey)]
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        // URLRequest 생성 (POST)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // HTTP Body (요청 본문) 업데이트
        let requestBody : [String: Any] = [
            "contents": [
                ["parts": [["text": Config.prompt(symptom: symptom)]]]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            throw NetworkError.decodingError(error)
        }
        
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await urlSession.data(for: request)
        } catch {
            throw NetworkError.requestFailed(error)
        }
        
        // 응답 코드 확인
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorBody = String(data: data, encoding: .utf8) ?? "No error Request Body"
            throw NetworkError.invalidResponse(httpResponse.statusCode, errorBody)
        }
        
        // 응답 데이터 디코딩
        do {
            // JSON 파싱
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               
                let candidates = jsonObject["candidates"] as? [Any],
                let firstCandidate = candidates.first as? [String: Any],
               
                let content = firstCandidate["content"] as? [String: Any],
               
                let parts = content["parts"] as? [Any],
                let firstPart = parts.first as? [String: Any],
               
                let text = firstPart["text"] as? String {
                
                return text

            } else{
                return ""
            }
        }
    }
}
