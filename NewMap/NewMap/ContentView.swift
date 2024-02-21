//
//  ContentView.swift
//  NewMap
//
//  Created by Cenk Bilgen on 2024-02-16.
//

import SwiftUI
import MapKit

struct ContentView: View {

    let toronto = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.65, longitude: -79.38),
        latitudinalMeters: 100,
        longitudinalMeters: 100)

    let burgerKings = [
        BurgerKing(openingTime: 9, closingTime: 11, coordinate: CLLocationCoordinate2D(latitude: 43.65, longitude: -79.38)),
        BurgerKing(openingTime: 12, closingTime: 2, coordinate: CLLocationCoordinate2D(latitude: 43.6502, longitude: -79.3802)),
    ]

    @State var selection: Int?

    var body: some View {
        VStack(spacing: 0) {
            Map(initialPosition: .automatic,
                selection: $selection) {

                ForEach(burgerKings.indices, id: \.self) { index in

                    // MARK: 1. Annotation

                    Annotation(coordinate: burgerKings[index].coordinate,
                               content: {
                        Image(systemName: "fork.knife")
                            .foregroundStyle(Color.red)
                            .padding()
                            .background(Circle()
                                .foregroundStyle(Color.gray.opacity(0.8)))
                            .scaleEffect(x: selection == index ? 1.5 : 1, y: selection == index ? 1.5 : 1)
                    }, label: {
                        Text("BK #\(index)")
                    })

                    // MARK: 2. Marker

                    //                    Marker("BK #\(index)", systemImage: "fork.knife", coordinate: burgerKings[index].coordinate)
                    //
                    //                    MapCircle(center: burgerKings[index].coordinate, radius: 50)
                    //                        .foregroundStyle(.orange.opacity(0.3))
                    //                        .stroke(.orange, lineWidth: 1)
                    //                }

                    // MARK: 3. UserAnnotation

                    //                UserAnnotation()

                    // MARK: 4. MapPolygon

                    MapPolygon(coordinates: ScarboroughVillage.coordinates)
                        .foregroundStyle(.pink.opacity(selection == 100 ? 0.9 : 0.3))
                        .stroke(.red, lineWidth: 2)
                        .tag(100)

                    // MARK: 5. MapPolyline

                    // Draw a line from first burgerking to first point of scarborough village
                    MapPolyline(coordinates: [
                        burgerKings[0].coordinate,
                        ScarboroughVillage.coordinates[0]
                    ])
                    .stroke(.yellow, style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5, 10]))

                }
            }
            .mapControlVisibility(.visible)
            .mapStyle(.hybrid)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }

            UIKitMapView(region: toronto)

            VStack {
                Spacer()
                Text("Hello")
                    .layoutPriority(1)
                Text("Selected: BK ID \(selection?.description ?? "")")
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}

// NOTE: Unlike MKAnnotation, this does not need to be a class or conform to any protocol
// but you need a coordinate to generate an Annotation
struct BurgerKing {
    let openingTime, closingTime: Int
    let coordinate: CLLocationCoordinate2D
}

struct UIKitMapView: UIViewRepresentable {

    let region: MKCoordinateRegion

    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.region = self.region
        view.delegate = context.coordinator
        return view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("UIView updated.")
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var countChange = 0

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            print("Region Changed \(countChange)")
            countChange += 1
        }
    }
}

struct ScarboroughVillage {

// Source: https://raw.githubusercontent.com/adamw523/toronto-geojson/master/simple.geojson

    private static let geoJSON: Data = """
{ "type": "Feature", "properties": { "DAUID": "35203305", "PRUID": "35", "CSDUID": "3520005", "HOODNUM": 139, "HOOD": "Scarborough Village", "FULLHOOD": "Scarborough Village (139)" }, "geometry": { "type": "Polygon", "coordinates": [ [ [ -79.208888200263701, 43.740614473298457 ], [ -79.20831973072589, 43.739257904235977 ], [ -79.208334219741573, 43.737785795103022 ], [ -79.207620567501863, 43.736065793703148 ], [ -79.205869087045045, 43.737748933198354 ], [ -79.204734971939175, 43.734986025277834 ], [ -79.205020037668774, 43.735071968110795 ], [ -79.204967973282905, 43.735269010490597 ], [ -79.205282981409397, 43.735333008306355 ], [ -79.206056042050662, 43.735070046890954 ], [ -79.208683949632885, 43.733149039548948 ], [ -79.212891031786043, 43.728527996457181 ], [ -79.21329597640802, 43.727872961894633 ], [ -79.21335502686658, 43.727256989513414 ], [ -79.213820969943967, 43.726777991822942 ], [ -79.214165606278897, 43.727263533651858 ], [ -79.215000117680461, 43.727591720982375 ], [ -79.216563820277514, 43.72761612631674 ], [ -79.218624243741473, 43.728053423795842 ], [ -79.220345481601356, 43.728629523627518 ], [ -79.220817993038779, 43.729023957054842 ], [ -79.222591841244167, 43.72950182169199 ], [ -79.223115868324726, 43.729834123762558 ], [ -79.223981450228678, 43.729955596346819 ], [ -79.224445064247732, 43.730232942778208 ], [ -79.224815048492829, 43.731157054927039 ], [ -79.225310872623126, 43.731387728412074 ], [ -79.22455985075355, 43.732080819890662 ], [ -79.228182712010721, 43.740622682140149 ], [ -79.228821153505663, 43.740996608919595 ], [ -79.228879789173391, 43.741442927025332 ], [ -79.224987250664554, 43.744242158057311 ], [ -79.220899931435468, 43.747841364073324 ], [ -79.219857302075326, 43.748457059173276 ], [ -79.217745780607729, 43.749297513114854 ], [ -79.213815399603817, 43.750316563284819 ], [ -79.211302344005844, 43.751170245543619 ], [ -79.211104929517035, 43.749995124397415 ], [ -79.20787495312608, 43.742525429878235 ], [ -79.208351330130256, 43.742152030645101 ], [ -79.208888200263701, 43.740614473298457 ] ] ] } }
""".data(using: .utf8)!

    private struct GeoJSON: Decodable {
        let geometry: Geometry

        struct Geometry: Decodable {
            // let type: String
            let coordinates: [[[Double]]]
            // it's an array of arrays
            // each inner array is of length 2 representing the coordinates
        }
    }

    static let coordinates: [CLLocationCoordinate2D] = {
        do {
            return try JSONDecoder().decode(GeoJSON.self, from: geoJSON)
                .geometry.coordinates[0]
                .map {
                    // switched
                    // latitude is the 2nd element of array
                    // longitude is the 1st element of the array
                    CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])
                }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }()

}
