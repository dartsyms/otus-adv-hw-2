//
//  NavPopButton.swift
//  hwappsecond
//

import SwiftUI

struct NavPopButton<Label: View>: View {
    @EnvironmentObject private var viewModel: CustomNavigationViewModel
    
    private var label: Label
    private var destination: PopDestination
    
    init(destination: PopDestination, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
            label
        }.onTapGesture {
            self.viewModel.pop(to: self.destination)
        }
    }
}

struct NavPopButton_Previews: PreviewProvider {
    static var previews: some View {
        NavPopButton(destination: .prev) {
            Text("Back")
        }
    }
}
