//
//  TagsListView.swift
//  hwappsecond
//

import SwiftUI

struct TagsListView: View {
    @StateObject var dataSource = TagsDataSource()
    
    var body: some View {
//        CustomNavigationView(transition: .custom(.moveAndFade, .moveBackAndFade)) {
        NavigationView {
            VStack {
                self.switcher
                self.tags
            }
            .onAppear {
                self.dataSource.load()
            }
//            .onDisappear {
//                self.dataSource.cancel()
//            }
            .navigationBarTitle("Tags", displayMode: .inline)
        }
            
    }
        
    
    private var switcher: some View {
        Picker(selection: $dataSource.switcher, label: Text("")) {
            Text("A to H").tag(CharcterInRange.fromAToH)
            Text("I to P").tag(CharcterInRange.fromItoP)
            Text("Q to Z").tag(CharcterInRange.fromQtoZ)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private var gridItemLayout = [GridItem(.adaptive(minimum: 60))]
    
    private var tags: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout) {
                ForEach(Array(self.dataSource.tags.enumerated()), id: \.element.id) { pair in
                    HStack {
                        TagRowView(viewModel: .init(tag: pair.element))
                    }
                    .onAppear {
                        if self.dataSource.tags.isLast(pair.element) {
                            self.dataSource.load()
                        }
                    }
                    
                    if self.dataSource.isLoading && self.dataSource.tags.isLast(pair.element) {
                        ProgressView()
                    }
                }
            }
        }
    }
}

struct TagsListView_Previews: PreviewProvider {
    static var previews: some View {
        TagsListView()
    }
}
