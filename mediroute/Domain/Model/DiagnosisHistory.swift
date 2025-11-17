//
//  DiagnosisHistory.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//
import Foundation
import SwiftData

@Model
final class DiagnosisHistory {
    
    var diagnosisTime: Date
    var symptom: String
    var diagnosisResult: String
    
    init(diagnosisTime: Date, symptom: String, diagnosisResult: String) {
        self.diagnosisTime = diagnosisTime
        self.symptom = symptom
        self.diagnosisResult = diagnosisResult
    }
}
