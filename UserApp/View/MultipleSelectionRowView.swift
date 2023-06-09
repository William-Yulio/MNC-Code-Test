//
//  MultipleSelectionRowView.swift
//  UserApp
//
//  Created by William Yulio on 08/06/23.
//

import SwiftUI

struct MultipleSelectionRowView: View {
    var image: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
//            HStack {
                AsyncImage(url: URL(string: image ?? "")!,
                           placeholder: { Text("Loading ...") },
                           image: { Image(uiImage: $0).resizable() })
                .frame(width: 200, height: 75 )
                .opacity(self.isSelected ? 0.5 : 1)
//            }
        }
    }
}
