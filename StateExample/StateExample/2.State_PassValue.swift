//
//  ContentView.swift
//  StateExample
//
//  Created by Cenk Bilgen on 2024-03-08.
//

import SwiftUI

/****************

Sample 2

MARK: The same as Sample 1

- updating "n" in ContentView triggers View1 to update
- View1 can only read the value it cannot trigger an update itself

**********************/

fileprivate struct ContentView: View {
    @State var n = 6

    var body: some View {
        VStack {
            View1(number: n)
                .border(.blue)

            Button(" n += 1") {
                n += 1
            }
            .padding()
            .border(.green)
        }
        .padding()
        .border(.red)
    }
}

fileprivate struct View1: View {
    let number: Int

    var body: some View {
        VStack {
            Image(systemName: "\(number).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
