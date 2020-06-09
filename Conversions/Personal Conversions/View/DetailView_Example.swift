//
//  DetailView_Example.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/9/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

struct DetailView_Example: View {
    @EnvironmentObject var personal: Personal
    let type: UnitType
    var distance: [Distance] = [.feet, .inches, .miles, .yards]
    @State private var fromDistance = 1
    @State private var toDistance = 2
    @State private var number = "0"
    var fromValue: String {
        return distance[fromDistance].rawValue
    }
    
    var toValue: String {
        return distance[toDistance].rawValue
    }
    
    init(type: UnitType) {
        self.type = type
    }
    var body: some View {
   
        VStack {
            Form {
                Section(header: Text("From")) {
//                    Text("From")
                    Picker(selection: $fromDistance, label: Text("Choose Distance")){
                        ForEach(0 ..< Distance.allCases.count) {index in
                            Text("\(Distance.init(id: index)!.rawValue)")
                        }
                    }
                }
                
                Section(header: Text("To")) {
//                    Text("To")
                    Picker(selection: $toDistance, label: Text("Choose Distance")){
                        ForEach(0 ..< Distance.allCases.count) {index in
                            Text("\(Distance.init(id: index)!.rawValue)")
                        }
                    }
                }
                
                Section(header: Text("Converting from \(fromValue) to \(toValue)")) {
                    TextField("\(fromValue)", text: $number)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("\(toValue)")) {
                    Text("\(Distances.init(to: distance[toDistance], from: distance[fromDistance]).inchesToFeet(in: Float(number)!))")
                }
            }
        }
        .navigationBarTitle(Text(type.rawValue), displayMode: .inline)
    }
}

struct DetailView_Example_Previews: PreviewProvider {
    let type: UnitType
    
    static var previews: some View {
        DetailView_Example(type: .craft)
    }
}
