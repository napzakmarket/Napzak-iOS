//
//  ContentView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 3/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Hello, world!")
                    .font(.napzakFont(.body1Bold16))
                    .lineSpacing(Font.toUIFont(.body1Bold16).lineHeight * 0.28)
                    .background(Color.blue)
                Text("Hello, world!")
                    .applyNapzakFont(.body1Bold16)
                    .background(Color.blue)
            }
            HStack {
                Text("Hello, world!\nHello, world!")
                    .font(.napzakFont(.body1Bold16))
                    .lineSpacing(Font.toUIFont(.body1Bold16).lineHeight * 0.28)
                    .background(Color.blue)
                Text("Hello, world!\nHello, world!")
                    .applyNapzakFont(.body1Bold16)
                    .background(Color.blue)
            }

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
