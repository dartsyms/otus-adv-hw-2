//
//  PostsListView.swift
//  hwappsecond
//

import SwiftUI

struct PostsListView: View {
    @StateObject var dataSource = PostsDataSource()
    
    var body: some View {
        NavigationView {
//        CustomNavigationView(transition: .custom(.moveAndFade, .moveBackAndFade)) {
            VStack {
                self.posts
            }
            .onAppear {
                self.dataSource.load()
            }
//            .onDisappear {
//                self.dataSource.cancel()
//            }
            .navigationBarTitle("Posts", displayMode: .inline)
        }
    }
    
    private var posts: some View {
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
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}
