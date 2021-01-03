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
                ForEach(self.dataSource.cachedPosts, id: \.postId) { post in
                    HStack {
                        PostRowView(viewModel: PostRowViewModel(post: post))
                    }
                    .onAppear {
                        if self.dataSource.cachedPosts.isLast(post) {
                            self.dataSource.loadCached()
                        }
                    }
                    
                    if self.dataSource.isLoading && self.dataSource.cachedPosts.isLast(post) {
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
