//
//  ContentView.swift
//  SampleApp
//
//  Created by Сергій Попов on 09.10.2023.
//

import SwiftUI
import StaticLib

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, \(Foo.foo)!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
