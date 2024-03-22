//
//  PetClassify.swift
//  PetClassifier
//
//  Created by Cenk Bilgen on 2024-03-22.
//

import Foundation
import Vision

enum Pet {
    case cat
    case dog
    case unknown

    init(observation: VNClassificationObservation) {
        self = switch observation.identifier {
            case "Cat":
                    .cat
            case "Dog":
                    .dog
            default:
                    .unknown
        }
    }
}

enum PetClassifyError: Error {
    case visionError
}

class PetClassifier {

    static func classify(image: CGImage) async throws -> (Pet, confidence: Float) {

        try await withCheckedThrowingContinuation { continuation in

            /* MARK: Step 1

             Create a RequestHandler
             - this is where the type of ML model you are using is determined
             from the request type (image, text, etc)

             - this is where the input is defined
             */

            let requestHandler = VNImageRequestHandler(cgImage: image, orientation: .up)

            /* MARK: Step 2

             Create your Request
             - this is the specific type of request
             - also you can add the completion handler (the code to call when performing the request is finished)

             -- about the completion handler
             - the completion handler will return you back the request and any (Optional) error

             */

            let request = VNRecognizeAnimalsRequest { request, error in

                // if this is being called, that means our request performance finished
                // and either request.result is set
                // or error is set

                if let error {

                    continuation.resume(throwing: error)

                } else {

                    if let results = request.results as? [VNRecognizedObjectObservation],
                          let firstResult = results.first,
                       let firstLabel = firstResult.labels.first {

                        let petType = Pet(observation: firstLabel)
                        let confidence = firstLabel.confidence
                        continuation.resume(returning: (petType, confidence))

                    } else {
                            continuation.resume(throwing: PetClassifyError.visionError)
                    }
                }
            }

            // NOTE: We need to go through this depending on whether
            // it on the simulator or not
            // simulator may not have access to GPU or NPUs

            // OLD Deprecated, but way easier
            // request.usesCPUOnly = true

            // NEW very complicated way, this is not robust code
            do {
                let supportedDevices = try request.supportedComputeStageDevices
                let mainDevice = supportedDevices[.main]?.last // through experience, try other indexes if it doesn't work
                print(mainDevice.debugDescription)

                request.setComputeDevice(mainDevice, for: .main)
                // just use the same for post-processing
                request.setComputeDevice(mainDevice, for: .postProcessing)
            } catch {
                continuation.resume(throwing: error)
            }

            /* MARK: Step 3

            - Perform the Request
             - if it doesn't throw an error here, it will take you to the closure of the request handler
             */

            do {
                try requestHandler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }

    }

}


