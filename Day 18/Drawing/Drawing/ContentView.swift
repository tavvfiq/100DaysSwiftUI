//
//  ContentView.swift
//  Drawing
//
//  Created by Taufiq Widi on 12/03/21.
//

import SwiftUI

struct ContentView: View {

    @State private var _gesture = CGPoint.zero
    @State private var _initialGesture = CGPoint.zero
    @State private var firstTapped = false

    var gestureTracker: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged {
                if !firstTapped {
                    self._initialGesture = $0.location
                    self.firstTapped = true
                } else {
                    self._gesture = $0.location
                }
                print("\(_initialGesture) \(_gesture)")
            }
            .onEnded { _ in
                self.firstTapped = false
            }
    }

    var body: some View {
        GeometryReader { (geo) in
            ZStack {
                // TODO: drawing line
                Path { path in
                    path.move(to: self._gesture)
                    path.addLine(to: self._gesture)
                }.stroke(Color.black, lineWidth: 0.5)            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.blue)
            .gesture(gestureTracker)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
