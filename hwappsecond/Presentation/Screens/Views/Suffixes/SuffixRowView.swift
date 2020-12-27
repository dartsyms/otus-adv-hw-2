//
//  SuffixRowView.swift
//  hwappsecond
//

import SwiftUI

struct SuffixRowView: View {
    @ObservedObject var viewModel: SuffixRowViewModel
    var body: some View {
        Text("\(viewModel.key) [\(viewModel.value) \(viewModel.value == 1 ? "time": "times")]")
            .lineLimit(1)
            .font(.system(size: 14))
            .foregroundColor(.primary)
            .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct SuffixRowView_Previews: PreviewProvider {
    static var previews: some View {
        SuffixRowView(viewModel: SuffixRowViewModel(key: "suffi", value: 4))
    }
}
