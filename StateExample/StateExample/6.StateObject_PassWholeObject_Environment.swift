//
//  ContentView.swift
//  StateExample
//
//  Created by Cenk Bilgen on 2024-03-08.
//

import SwiftUI
import PhotosUI

/****************

Sample 6

MARK: Passing the ObservedObject to a child View through the Environment

 Difference from 5.
 - passing an ObservedObject down the View hierarchy requires every View to keep passing the object down as an argument, this can be tedious

 - numberModel is initialized only in the parent View as a @StateObject
 - the parentView add `.environmentObject()` modifier to pass that _all_ child Views lower in the hierarchy
 - any child View can then access that ObservableObject by creating a reference with `@EnvironmentObject` (they don't have to, if they don't use it)


 ********************/

fileprivate class NumberModel: ObservableObject {
    @Published var n = 6
    @Published var m = 10
    @Published var x = 20
}

fileprivate struct ContentView: View {
    @StateObject var model = NumberModel()

    var body: some View {
        VStack {
            View1()
                .border(.blue)
                .environmentObject(model) // <----

            Button(" Zero n", action: {
                model.n = 0
            })
            .padding()
            .border(.red)
        }
        .border(.orange)
    }
}

fileprivate struct View1: View {
    @EnvironmentObject var model: NumberModel // <---

    var body: some View {
        VStack {
            Image(systemName: "\(model.n).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()

            Image(systemName: "\(model.m).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()

            Image(systemName: "\(model.x).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()

            AddView()
        }
    }

    struct AddView: View {
        @EnvironmentObject var model: NumberModel
        @State var showPhotoPicker = false
        @State var selection: PhotosPickerItem?

        var body: some View {
            Button(" n = n + 1") {
                model.n += 1
                showPhotoPicker = true
            }
            .padding()
            .border(.red)
            .photosPicker(isPresented: $showPhotoPicker, selection: $selection)
        }
    }
}

#Preview {
    ContentView()
}

