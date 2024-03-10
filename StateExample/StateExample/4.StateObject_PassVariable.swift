//
//  ContentView.swift
//  StateExample
//
//  Created by Cenk Bilgen on 2024-03-08.
//

//
//  ContentView.swift
//  StateExample
//
//  Created by Cenk Bilgen on 2024-03-08.
//

import SwiftUI

/****************

Sample 4

MARK: Passing a variable from an ObservedObject to a child View

 Difference from 4.
 The variable "n" is moved outside any View and into a seperate model class.
 @StateObject instead of just a @State

 - "n" is initialized in the parent View only

 - updating "n" in ContentView triggers View1 to update
 - updating "n" in View1 triggers ContentView to update

 ***********************/

fileprivate class NumberModel: ObservableObject {
    @Published var n = 6
    @Published var m = 10
}

fileprivate struct ContentView: View {
    @StateObject var model = NumberModel()

    var body: some View {
        VStack {
            View1(n: $model.n, m: model.m)
                .border(.blue)
                .environmentObject(model)

            Button(" Zero n", action: {
                model.n = 0
            })
        }
        .border(.orange)
    }
}

fileprivate struct View1: View {
    @Binding var n: Int  // this View can update n
    let m: Int // this View can only read m (and get updates)

    var body: some View {
        VStack {
            Image(systemName: "\(n).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()
            Button(" n = n + 1") {
                n += 1
            }
            .padding()
            .border(.red)


            Image(systemName: "\(m).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
