//
//  CSS_PersonalView.swift
//  Conversions
//
//  Created by Daimen Ambers on 11/27/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI
import CoreData


/// The view to show every personal conversion
struct CSS_PersonalView: View {
    @EnvironmentObject var personal: Personal
    //    @Environment(\.managedObjectContext) var moc
    @State private var showCreateView = false
    @State private var editMode: EditMode = .inactive
    
    //    @FetchRequest(entity: SavedConversion.entity(), sortDescriptors: []) var conversion: FetchedResults<SavedConversion>
    
    var body: some View {
        NavigationView {
            if !personal.conversion.isEmpty {
                List {
                    // Detail view should list all personal coneversions
                    ForEach(personal.conversion) { conversion in
                        NavigationLink(destination: DetailView(conversion: conversion)) {
                            ZStack {
                                
                            
                            Text("\(conversion.title)")
                                .contextMenu {
                                    Text(String(conversion.baseUnit))
                                    Section {
                                        Button(action: {
                                            //Share
                                        }) {
                                            HStack {
                                                Image(systemName: "square.and.arrow.up")
                                                Spacer()
                                                Text("Share")
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Personal Conversions")
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(action: {
                        //Creates a new conversion
                        self.showCreateView.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 20))
                    })
                .environment(\.editMode, $editMode)
            } else {
                Placeholder(showCreateView: $showCreateView)
                    .navigationBarTitle("Personal Conversions")
                    .navigationBarItems(
                        leading: EditButton().disabled(true),
                        trailing: Button(action: {
                            //Creates a new conversion
                            self.showCreateView.toggle()
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 20))
                        })
                    .environment(\.editMode, $editMode)
            }
        }.sheet(isPresented: $showCreateView) {
            CreateView(personal: self.personal)
        }
    }
    
    func delete(at offsets: IndexSet) {
        personal.conversion.remove(atOffsets: offsets)
        if personal.conversion.isEmpty {
            editMode = .inactive
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        personal.conversion.move(fromOffsets: source, toOffset: destination)
    }
}

struct CSS_PersonalView_Previews: PreviewProvider {
    static var previews: some View {
        CSS_PersonalView().environmentObject(Personal())
    }
}
