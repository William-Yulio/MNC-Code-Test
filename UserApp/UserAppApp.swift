//
//  UserAppApp.swift
//  UserApp
//
//  Created by William Yulio on 02/06/23.
//

import SwiftUI

@main
struct UserAppApp: App {
    @StateObject var VM = ViewModel()
    @StateObject var novelVM = NovelViewModel()
    @StateObject var addNovelVM = AddNovelViewModel()
    var body: some Scene {
        WindowGroup {
            TabView{
                ContentView()
                    .environmentObject(VM)
                    .tabItem {
                        Label("User Age", systemImage: "person")
                    }
                ListNovelView()
                    .environmentObject(novelVM)
                    .tabItem {
                        Label("List Novel", systemImage: "book")
                    }
                AddNovelView()
                    .environmentObject(addNovelVM)
                    .tabItem {
                        Label("Add New Novel", systemImage: "doc.fill.badge.plus")
                    }
            }
        }
    }
}
