//
//  NavPushButton.swift
//  hwappsecond
//

import SwiftUI

struct NavPushButton_Previews: PreviewProvider {
    static var previews: some View {
        NavPushButton(destination: EmptyView()) {
            Text("More...")
        }
    }
}

struct NavPushButton<Label: View, Destination: View>: View {
    @EnvironmentObject private var viewModel: CustomNavigationViewModel
    
    private var label: Label
    private var destination: Destination
    
    init(destination: Destination, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        HStack {
            label
            Image(systemName: "chevron.right")
        }.onTapGesture {
            self.viewModel.push(self.destination)
        }
    }
}


