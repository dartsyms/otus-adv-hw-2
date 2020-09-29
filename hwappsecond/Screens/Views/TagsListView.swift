//
//  TagsListView.swift
//  hwappsecond
//
//  Created by sanchez on 22.09.2020.
//

import SwiftUI

struct TagsListView: View {
    @ObservedObject var viewModel: TagsListViewModel = TagsListViewModel()
    var body: some View {
        CustomNavigationView(transition: .custom(.moveAndFade, .moveBackAndFade)) {
            VStack {
                Picker(selection: $viewModel.switcher, label: Text("")){
                    Text("A to H").tag(CharcterInRange.fromAToH)
                    Text("I to P").tag(CharcterInRange.fromItoP)
                    Text("Q to Z").tag(CharcterInRange.fromQtoZ)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onAppear {
                    self.viewModel.load()
                }
                Spacer()
            }
            
        }
        
    }
}

struct TagsListView_Previews: PreviewProvider {
    static var previews: some View {
        TagsListView(viewModel: TagsListViewModel())
    }
}
