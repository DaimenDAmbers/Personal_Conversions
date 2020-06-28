//
//  PersonalConversionsView.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/12/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI
import CoreData


/// The view to show every personal conversion
struct PersonalView: View {
    @EnvironmentObject var personal: Personal
    @Environment(\.managedObjectContext) var moc
    @State private var showCreateView = false
    
//    @FetchRequest(entity: SavedConversion.entity(), sortDescriptors: []) var conversion: FetchedResults<SavedConversion>
    
    var body: some View {
        NavigationView {
            if !personal.conversion.isEmpty {
                List {
                    // Detail view should list all personal coneversions
                    ForEach(personal.conversion) { conversion in
                        NavigationLink(destination: DetailView(conversion: conversion)) {
                            Text("\(conversion.title)")
                                .contextMenu {
                                    Text(String(conversion.unitName))
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
            } else {
                Placeholder(showCreateView: $showCreateView)
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
            }
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

struct Placeholder: View {
    @Binding var showCreateView: Bool
    var body: some View {
        Button(action: {
            self.showCreateView.toggle()
        }) {
            Text("Add a conversion")
                .font(.headline)
        }
    }
}

struct PersonalView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalView().environmentObject(Personal())
    }
}
