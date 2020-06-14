//
//  PersonalConversionsView.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/12/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

/// The view to show every personal conversion
struct PersonalView: View {
    @EnvironmentObject var personal: Personal
    @State private var showCreateView = false
    
    var body: some View {
        NavigationView {
            List {
                // Detail view should list all personal coneversions
                ForEach(personal.conversion) { conversion in
                    NavigationLink(destination: DetailView(conversion: conversion)) {
                        Text("\(conversion.title)")
                            .contextMenu {
                                Text(String(conversion.unitName))
                        }
                    }
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Personal")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    //Creates a new conversion
                    self.showCreateView.toggle()
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 20))
            })
        }.sheet(isPresented: $showCreateView) {
            CreateView(personal: self.personal)
        }
    }
    
    func delete(at offsets: IndexSet) {
        personal.conversion.remove(atOffsets: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        personal.conversion.move(fromOffsets: source, toOffset: destination)
    }
}

struct PersonalView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalView().environmentObject(Personal())
    }
}
