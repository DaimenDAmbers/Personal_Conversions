//
//  ContentView.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/9/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var personal: Personal

    var body: some View {
        TabView {
            PersonalView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Personal")
            }
//            Divider()
            UniversalView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("Universal")
            }
        }
        .font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Personal())
    }
}
