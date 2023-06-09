//
//  ContentView.swift
//  UserApp
//
//  Created by William Yulio on 02/06/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var VM =  ViewModel()
    var count = 0
    var body: some View {
        NavigationView{
            VStack {
                List(){
                    Text("Range user age between 0 - 10 = \(VM.a) users")
                    Text("Range user age between 11 - 20 = \(VM.b) users")
                    Text("Range user age between 21 - 30 = \(VM.c) users")
                    Text("Range user age between 31 - \(VM.maxAge) = \(VM.d) users")
                }
                
                
            }
            .onAppear(){
                VM.fetchUserData()
                //            VM.calculateAge()
            }
            .navigationTitle("Calculate Average Age")
        }
    }
}
