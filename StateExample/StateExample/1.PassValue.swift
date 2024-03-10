//
//  ContentView.swift
//  StateExample
//
//  Created by Cenk Bilgen on 2024-03-08.
//

import SwiftUI

/****************

Sample 1

MARK: Pass a Value to a child View

***********************/

fileprivate struct ContentView: View {

    let number = 5

    var body: some View {
        VStack {
            View1(number)
                .border(.blue)
        }
        .padding()
        .border(.red)
    }
}

fileprivate struct View1: View {
    let n: Int

    init(_ n: Int) {
        self.n = n
    }

    var body: some View {
        VStack {
            Image(systemName: "\(n).circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
