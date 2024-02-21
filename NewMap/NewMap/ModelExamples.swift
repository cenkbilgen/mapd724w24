//
//  ModelExamples.swift
//  NewMap
//
//  Created by Cenk Bilgen on 2024-02-20.
//

import SwiftUI

/*

 @State (used only inside View)
 @State <-> @Binding (for another View to use)
 @Published (in an ObservedObject) <-> @Binding

 @StateObject (used only inside View)
 @StateObject <-> @ObservedObject (for another View to use)
 @StateObject <-> @EnvironmentObject (for another View and all that Views children to use)

 */


// MARK 1:
// The child View is only reading (not modifying) a value from a parent View
// use just let (or var with default value)

struct BigTitle: View {
    let text: String // or `var text: String = "Untitled"`

    var body: some View {
        Text(text)
            .font(.headline.bold())
            .padding()
            .background(.yellow)
    }
}

// MARK 2: @State
// A View has a property that should cause it to udpate when the value changes
// and the view is _initializing_ that property
// note, it must be initalized to something

struct UpdatingView: View {
    @State var count = 100

    var body: some View {
        Text("Value: \(count). Tap to increase.")
            .background(Color.yellow // note attaching the gesture to the solid color
                .onTapGesture {
                    count += 1
                })
    }
}

//-------

let calendar = Calendar(identifier: .gregorian)

struct DateTitle: View {
    @State var date: Date = DateComponents(calendar: calendar, year: 2024, month: 5, day: 1).date!

    var body: some View {
        HStack {
            Text("Date: \(date.formatted(date: .numeric, time: .omitted))")
            Button("Next") {
                self.date = calendar.date(byAdding: .day, value: 7, to: date)!
            }
        }
    }
}

// MARK 2: @Binding
// A View has property that should cause it to udpate when the value changes
// and the view is _NOT initializing_ that property, it's initialized elsewhere
// note, it can't be initialized here, just declared
// each example needs two views one that initializes, one that takes the binding


struct ModifyDateButton: View {
    let title: String
    @Binding var date: Date // type is Binding<Date>, not Date
    let days: Int

    var body: some View {
        Button(title) {
            self.date = calendar.date(byAdding: .day, value: days, to: date)!
        }
    }
}

struct DateTitleComposed: View {

    @State var date: Date = DateComponents(calendar: calendar, year: 2024, month: 5, day: 1).date!

    var body: some View {
        HStack {
            Text("Date: \(date.formatted(date: .numeric, time: .omitted))")
            ModifyDateButton(title: "Previous", date: $date, days: -7)
        }
    }
}

/*---------------------------------------------------------*/

// MARK 3: @StateObject
// Similar to @State but works with an ObservableObject type instead of basic type.
// The ObservableObject will have some @Published variables
// Similar to @State the view declares and initializes the object.

class DateModel: ObservableObject {
    @Published var date: Date = DateComponents(calendar: calendar, year: 2024, month: 5, day: 1).date!
    var otherVariable = 10 // changes to this won't update the UI, it's not @Published
}

struct DateTitleObservable: View {
    @StateObject var model = DateModel()

    var body: some View {
        HStack {
            Text("Date: \(model.date.formatted(date: .numeric, time: .omitted))")
            ModifyDateButtonFromObservedObject(title: "Previous", state: model, days: -7)
        }
    }
}

// MARK 3: @ObservedObject/@EnvironmentObject
// Similar to @State but works with an ObservableObject type instead of basic type.
// The ObservableObject will have some @Published variables
// Similar to @State the view declares and initializes the object.


struct ModifyDateButtonFromObservedObject: View {
    let title: String
    @ObservedObject var state: DateModel
    let days: Int

    var body: some View {
        Button(title) {
            state.date = calendar.date(byAdding: .day, value: days, to: state.date)!
        }
    }
}

struct DateTitlePassingObservedObject: View {
    @StateObject var model = DateModel()

    var body: some View {
        HStack {
            Text("Date: \(model.date.formatted(date: .numeric, time: .omitted))")
            ModifyDateButton(title: "Previous", date: $model.date, days: -7)
        }
    }
}

// @EnvironmentObject is a shorthand
// every childView starting from where `.environmentObject(model)` will have access to the model. Here it's attached to the HStack, so it and all the view and their subviews, just have to declare
// @EnvironmentObject var state: DateModel
// the connection is made based on the type, since model is `DateModel` type
// some or most children views don't care about the DateModel, even though they still have acess to it, if they are not using it then they just wont make the @EnivornemntObject declaration.

struct ModifyDateButtonWithEnvironmentObject: View {
    let title: String
    let days: Int

    @EnvironmentObject var state: DateModel // <-------------

    var body: some View {
        Button(title) {
            state.date = calendar.date(byAdding: .day, value: days, to: state.date)!
        }
    }
}

struct DateTitleWithEnvironmentObject: View {
    @StateObject var model = DateModel()

    var body: some View {
        HStack {
            Text("Date: \(model.date.formatted(date: .numeric, time: .omitted))")
            ModifyDateButtonWithEnvironmentObject(title: "Previous", days: -7)
        }
        .environmentObject(model) // <--------------
    }
}



/* While working with autocomplete you may have also seen @Bindable and @Observable */
/* Ignore these for now. They are part of a different update mechanism called Observation that was introduced in iOS17 */
/* The new framework is much easier to work with and avoids some of the weirdness (like why are objects declared @StateObject and everything else @State, why can't just everything be declared with @State?), but most existing code does not make use of it yet */


//#Preview {
//    ModelExamples()
//}
