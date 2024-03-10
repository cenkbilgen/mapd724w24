//
//  ContentView.swift
//  StateExample
//
//  Created by Cenk Bilgen on 2024-03-08.
//

import SwiftUI

/****************

Sample 3

MARK: Binding a variable between Views

 Difference from 2. Update button is moved to the child view.

 - "n" is initialized in the parent View only

 - updating "n" in ContentView triggers View1 to update
 - updating "n" in View1 triggers ContentView to update

 ***********************/

fileprivate struct ContentView: View {
    @State var n = 6

    var body: some View {
        VStack {
            View1(n: $n)
                .border(.blue)
        }
        .padding()
        .border(.red)
    }
}

fileprivate struct View1: View {
    @Binding var n: Int // note initialized by parent

    var body: some View {
        VStack {
            Image(systemName: "\(n).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()

            Button(" n += 1") {
                n += 1
            }
            .padding()
            .border(.green)
        }
    }
}

#Preview {
    ContentView()
}

