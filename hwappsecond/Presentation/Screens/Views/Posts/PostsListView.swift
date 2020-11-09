//
//  PostsListView.swift
//  hwappsecond
//

import SwiftUI
import CustomNavigation

struct PostsListView: View {
    var body: some View {
        CustomNavigationView(transition: .custom(.moveAndFade, .moveBackAndFade)) {
            PostsScreen()
        }
    }
}

struct PostsScreen: View {
    @StateObject var dataSource = PostsDataSource()
    var body: some View {
        VStack {
            List {
                ForEach(Array(self.dataSource.posts.enumerated()), id: \.element.id) { pair in
                    HStack {
                        PostRowView(viewModel: PostRowViewModel(post: pair.element))
                    }
                    .onAppear {
                        if self.dataSource.posts.isLast(pair.element) {
                            self.dataSource.load()
                        }
                    }
                    
                    if self.dataSource.isLoading && self.dataSource.posts.isLast(pair.element) {
                        ProgressView()
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            self.dataSource.load()
        }
        .onTapGesture {
            
        }
        .navigationBarTitle("Posts", displayMode: .inline)
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}
