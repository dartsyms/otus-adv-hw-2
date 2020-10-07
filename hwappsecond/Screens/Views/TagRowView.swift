//
//  TagRowView.swift
//  hwappsecond
//

import SwiftUI

struct TagRowView: View {
    @ObservedObject var viewModel: TagRowViewModel
    var body: some View {
        Text(viewModel.tag.title ?? "")
            .lineLimit(1)
            .font(.system(size: 12))
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(7)
            .background(Capsule().stroke())
    }
}

struct TagRowView_Previews: PreviewProvider {
    static var previews: some View {
        TagRowView(viewModel: TagRowViewModel(tag: Tag(title: "DummyTag")))
    }
}
