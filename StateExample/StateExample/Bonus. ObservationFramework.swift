//
//  ContentView.swift
//  StateExample
//
//  Created by Cenk Bilgen on 2024-03-08.
//

import SwiftUI

/****************

 Observation Framework was introduced to make things easier and more performant. It is only available on iOS 17 and later.

  Advantages:
    - smaller and easier syntax
    - triggers fewer View updates (for multiple reasons)
    - works with Optionals (allows much simpler architecture)
    - not just for SwiftUI, meant to be used to observe variable changes in any kind of code

Old Syntax:
    ObservableObject, @Published, @ObservedObject, @StateObject, @EnvironmentObject, @State, @Binding

New Syntax:
    @Observable, @State, @Binding, @Environment

 Reference:
 https://developer.apple.com/documentation/Observation

 This is a very useful outline for migrating an app from Combine-based data observation to Observation Framework based observation

 https://developer.apple.com/documentation/SwiftUI/Migrating-from-the-observable-object-protocol-to-the-observable-macro


******************/

import Observation

@Observable fileprivate class NumberModel {
    var n = 6
    var m = 10
    @ObservationIgnored var x = 20 // opt-out
}

fileprivate struct ContentView: View {
    let numberModel: NumberModel? = NumberModel()
    // NumberModel is @Observable

    var body: some View {
        VStack {
            View1()
                .border(.blue)
                .environment(numberModel) // <----

            Button(" Zero n", action: {
                numberModel?.n = 0
            })
        }
        .border(.orange)
    }
}

fileprivate struct View1: View {
    @Environment(NumberModel.self) var model // <---- connection is made by the type "NumberModel"

    var body: some View {
        VStack {
            Image(systemName: "\(model.n).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()
            AddView()

            Image(systemName: "\(model.m).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()

            Image(systemName: "\(model.x).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()
        }
    }

    struct AddView: View {
        @Environment(NumberModel.self) var model

        var body: some View {
            Button(" n = n + 1") {
                model.n += 1
            }
            .padding()
            .border(.red)
        }
    }
}

#Preview {
    ContentView()
}

