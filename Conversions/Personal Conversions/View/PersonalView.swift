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
                        HStack {
                            NavigationLink(destination: DetailView(conversion: conversion)) {
                                HStack {
                                    ZStack { // Create the captial letter in it's bubble
                                        Circle()
                                            .fill(conversion.color)
                                            .frame(width: 50, height: 50, alignment: .center)
                                        Text(conversion.acronym)
                                            .foregroundColor(conversion.acronymTextColor)
                                    }
                                    
                                    VStack (alignment: .leading) { //Title and base unit name
                                        Text("\(conversion.title)")
                                            .font(.system(size: 17, weight: .heavy))
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
                                        Text(conversion.baseUnit)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        
                        .padding()
//                        .listRowBackground(conversion.color)
//                        .background(conversion.color)
                        .cornerRadius(8)
                        .shadow(radius: 8)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
                .listStyle(PlainListStyle())
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

struct AddConversionButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color(.systemBlue))
            .cornerRadius(15)
            .padding(.horizontal, 40)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
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
    .buttonStyle(AddConversionButtonStyle())
    }
}

struct PersonalView_Previews: PreviewProvider {
    static let personal = Personal()
    
    static var previews: some View {
        PersonalView().environmentObject(personal)
    }
}
