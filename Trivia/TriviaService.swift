//
//  TriviaService.swift
//  Trivia
//
//  Created by Cenk Bilgen on 2024-02-16.
//

import Foundation
import SwiftUI
import Combine

// NOTE: Could make a separate ObservableObject, but here the only state is an array of questions, so just using a @State variable in the view

//class TriviaModel: ObservableObject {
//    @Published var questions: [String] = []
//
//    func getNewQuestions(count: Int) {
//        Task {
//            do {
//                let questions = try await TriviaService.getQuestions(count: count)
                // fix: do on main thread
//                self.questions = questions
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//}

struct TriviaService {

    static var baseURL = URL(string: "https://opentdb.com/api.php")!

    // example of what NOT to do, never force unwrap unless you are 100% sure it will not return nil
//    func makeURL(count: Int) -> URL {
//        URL(string: "https://opentdb.com/api.php?amount=\(count)")!
//    }

    static func getQuestions(count: Int) async throws -> [Question] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "amount", value: String(count))
        ]
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        print("GET \(url.absoluteString)")

        // METHOD 1: request using Swift async/await
        let (data, response) = try await URLSession.shared.data(from: url)
        print(data)
        print(String(data: data, encoding: .utf8)!)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decodedBody = try decoder.decode(GetQuestionResponse.self, from: data)
        return decodedBody.results

        // -----------------------------------------------------
    }

    // METHOD 2: request using Combine
    
        var cancellable: AnyCancellable?

        let result = Future<[Question], Error> { continuation in
            let request = URLRequest(url: url)
            cancellable = URLSession.DataTaskPublisher(request: request, session: .shared)
            // Output: (Data, URLResponse) | Failure: Error
            // tryMap is exactly like map, but can also throw an error that gets published as a failure
                .tryMap { (data, response) in
                    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
            // Output: Data | Failure: Error
                .decode(type: GetQuestionResponse.self, decoder: decoder)
            // Output GetQuestionResponse | Failure: Error
                .sink { completion in
                    switch completion {
                        case .finished:
                            print("Done")
                        case .failure(let error):
                            print(error.localizedDescription)
                            continuation(.failure(error))
                    }
                } receiveValue: { decodedBody in
                    continuation(.success(decodedBody.results))
                }
        }
        return try result
    }

    // Alternatives



    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    let a: Int = {
        return 2 + 3
    }()
}

/*
{
    "response_code": 0,
    "results": [
        {
            "type": "multiple",
            "difficulty": "hard",
            "category": "Entertainment: Video Games",
            "question": "In &quot;Need for Speed III: Hot Pursuit&quot;, what is the name of the fictional car?",
            "correct_answer": "El Ni&ntilde;o",
            "incorrect_answers": [
                "R&aacute;pido",
                "&Aacute;gil",
                "La Ni&ntilde;a"
            ]
        },
        {
            "type": "multiple",
            "difficulty": "easy",
            "category": "Entertainment: Film",
            "question": "Who starred in the film 1973 movie &quot;Enter The Dragon&quot;?",
            "correct_answer": "Bruce Lee",
            "incorrect_answers": [
                "Jackie Chan",
                "Jet Li",
                " Yun-Fat Chow"
            ]
        }
    ]
}

*/


struct GetQuestionResponse: Decodable {
    // let response_code: Int
    let results: [Question]
}

struct Question: Decodable {
    let type: String?
    let difficulty: Difficulty
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    enum Difficulty: String, Decodable {
        case easy, hard, medium

        // when using enum the json value may not match any of the cases, and the whole decoding will fail
        // make a custom initializer to always initialize to something (here just medium if nothing matches), the RawValue type is String here
        // see the Swift reference on Enum

        // or use a third party package like https://github.com/airbnb/ResilientDecoding
        // but we haven't really covered how yet

        enum DifficultyWithRawValue: String, Codable {
            case easy, hard, medium

            init?(rawValue: RawValue) {
                switch rawValue {
                    case "easy":
                        self = .easy
                    case "hard":
                        self = .hard
                    default:
                        self = .medium
                }
            }
        }
    }
}
