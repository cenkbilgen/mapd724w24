//
//  ContentView.swift
//  StateExample
//
//  Created by Cenk Bilgen on 2024-03-08.
//

import SwiftUI

/****************

Sample 5

MARK: Passing the ObservedObject to a child View

 Difference from 4:
 - if using many variable from the same ObservedObject, passing the whole object to View is easier than passing each variable seperately.

 - numberModel is initialized only in the parent View as a @StateObject
 - the child View argument for the object marked as @ObservedObject

 ********************/

fileprivate class NumberModel: ObservableObject {
    @Published var n = 6
    @Published var m = 10
    @Published var x = 20
}

fileprivate struct ContentViewEnvironmentObject: View {
    @StateObject var numberModel = NumberModel()

    var body: some View {
        VStack {
            View1(model: numberModel)
                .border(.blue)

            Button(" Zero n", action: {
                numberModel.n = 0
            })
            .padding()
            .border(.red)
        }
        .padding()
        .border(.orange)
    }
}

fileprivate struct View1: View {
    @ObservedObject var model: NumberModel

    var body: some View {
        VStack {
            Image(systemName: "\(model.n).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()

            Button(" n = n + 1") {
                model.n += 1
            }

            Image(systemName: "\(model.m).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()

            Button(" m = m + 1") {
                model.m += 1
            }

            Image(systemName: "\(model.x).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()

        }
    }
}

#Preview {
    ContentViewEnvironmentObject()
}

