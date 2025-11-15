//
//  MainTabView.swift
//  mediroute
//
//  Created by 황진우 on 11/15/25.
//
import SwiftUI

struct MainTabView : View {
    var body : some View {
        TabView {
            NavigationView {
                SymptomInputView()
                   
            }.tabItem {
                Image(systemName: "pencil.and.scribble")
                Text("증상 찾기")
            }
            
            NavigationView {
                HistoryView()
            }
            .tabItem {
                Image(systemName: "list.bullet.clipboard")
                Text("기록")
            }
        }
    }
}
