//
//  FloatingPanelView.swift
//  manifest
//
//  Created by Adrian on 28/5/23.
//
import SwiftUI

struct FloatingPanelView: View {
    @State private var images = [URL]()

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(images, id: \.self) { url in
                    AsyncImage(url: url)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FloatingPanelView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingPanelView()
    }
}
