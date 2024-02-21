//
//  ContentView.swift
//  Trivia
//
//  Created by Cenk Bilgen on 2024-02-16.
//

import SwiftUI

struct ContentView: View {
    @State var error: Error?
    @State var questions: [Question] = []


    let students: [Student] = [
        Student(name: "Jack"),
        Student(name: "Jill"),
        Student(name: "Edgar"),
        Student(name: "Bill"),
        Student(name: "Edgar")
    ]

    var body: some View {
        VStack {
            Button {
                getNewQuestions()
            } label: {
                Text("Get new questions")
            }
            .buttonStyle(.bordered)

            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text(error?.localizedDescription ?? "")
            List(questions.indices, id: \.self) { index in
                Text(questions[index].question)
            }

            List(students.indices, id: \.self) { index in
                Text(students[index].name)
            }
        }
        .padding()
        .task {
            getNewQuestions()
        }
    }

    private func getNewQuestions() {
        Task {
            do {
                self.questions = try await TriviaService.getQuestions(count: 3)
                self.error = nil
            } catch {
                self.error = error
            }
        }
    }
}

#Preview {
    ContentView()
}



struct Student {
    let name: String
    let studentNumber = UUID().uuidString
}
