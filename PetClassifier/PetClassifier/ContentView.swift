//
//  ContentView.swift
//  PetClassifier
//
//  Created by Cenk Bilgen on 2024-03-22.
//

import SwiftUI
import PhotosUI

@MainActor class ContentModel: ObservableObject {
    @Published var image: Image?
    @Published var pet: Pet?
    @Published var confidence: Float?
}

struct ContentView: View {

    @StateObject var model = ContentModel()

    @State var showPhotoPicker = false
    @State var photo: PhotosPickerItem?

    var body: some View {
        VStack {
            VStack {
                model.image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()

                VStack {
                    switch model.pet {
                        case .none:
                            EmptyView()
                        case .unknown:
                            Text("Unknown")
                        case .cat:
                            Label("cat", systemImage: "cat")
                        case .dog:
                            Label("dog", systemImage: "dog")
                    }


                    Text("Confidence: \(model.confidence?.formatted(.number.precision(.fractionLength(2))) ?? "")")
                        .opacity(model.confidence == nil ? 0 : 1)
                        .font(.caption.weight(.bold))
                }
                .padding()
            }
            .border(.gray, width: model.image == nil ? 0 : 2)
            .padding()

            Spacer()

            Button("Select Photo") {
                showPhotoPicker = true
            }
            .padding()
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $photo)
        .onChange(of: photo) { _, newValue in
            // reset
            model.image = nil
            model.pet = nil
            model.confidence = nil

            guard let photo = newValue else {
                model.image = nil // deselected
                return
            }

            photo.loadTransferable(type: Image.self) { result in
                do {
                    let image = try result.get() // even if result is success, could be nil
                    Task { @MainActor in
                        model.image = image
                    }
                    Task { [image, model] in
                        if let image,
                           let cgImage = ImageRenderer(content: image).cgImage {

                            print("Determinig Pet")

                            do {
                                let (pet, confidence) = try await PetClassifier.classify(image: cgImage)

                                print("Pet is \(pet)")
                                Task { @MainActor in
                                    model.pet = pet
                                    model.confidence = confidence
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
