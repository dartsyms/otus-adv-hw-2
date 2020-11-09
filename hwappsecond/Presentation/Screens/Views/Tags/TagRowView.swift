//
//  TagRowView.swift
//  hwappsecond
//

import SwiftUI
import DummyApiNetworkClient

struct TagRowView: View {
    @ObservedObject var viewModel: TagRowViewModel
    var body: some View {
        Text(viewModel.tag.title ?? "")
            .lineLimit(1)
            .font(.system(size: 12))
            .foregroundColor(.white)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(7)
            .background(Capsule().fill(Color(red: 32/255, green: 36/255, blue: 38/255)))
            .overlay(Capsule().stroke(Color.white, lineWidth: 4))
    }
}

struct TagRowView_Previews: PreviewProvider {
    static var previews: some View {
        TagRowView(viewModel: TagRowViewModel(tag: Tag(title: "DummyTag")))
    }
}
