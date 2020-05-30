//
//  TypesView.swift
//  TypesView
//
//  Created by Daimen Ambers on 5/9/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

struct TypesView: View {
    @EnvironmentObject var personal: Personal
    
    let types: [UnitType] = [.chemistry, .cooking, .craft, .distance, .physics]
//    var action = { (type: String) in
//        print("\(type)")
//    }
    
    var action: () -> ()
    @State private var showModal = false
    @State private var showingSheet = false
    var body: some View {
        NavigationView {
//            List(types, id: \.self) { type in
//                NavigationLink(destination: DetailView(type: type)) {
//                    Text("\(type.rawValue)")
//                }
//            }
//            .navigationBarTitle("Tutorials")
//            .navigationBarItems(trailing:
//                Button(action: {
//                    print("Edit button pressed...")
//                }) {
//                    Image(systemName: "pencil.circle")
//                }
//            )
            Button(action: {
                self.showingSheet = true
            }) {
                Text("Show Action Sheet")
            }
            .actionSheet(isPresented: $showingSheet) {
                ActionSheet(title: Text("What do you want to do?"), message: Text("There's only one choice..."), buttons: [.default(Text("Dismiss Action Sheet"))])
            }
        }
        
    }

}

struct TypesView_Previews: PreviewProvider {
    static var previews: some View {
        TypesView(action: {})
    }
}
