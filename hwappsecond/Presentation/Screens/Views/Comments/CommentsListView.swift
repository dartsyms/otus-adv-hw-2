//
//  CommentsView.swift
//  hwappsecond
//

import SwiftUI

struct CommentsListView: View {
    @ObservedObject var dataSource: CommentsDataSource
    
    init(dataSource: CommentsDataSource) {
        self.dataSource = dataSource
    }
    
    var body: some View {
        VStack {
            self.comments
        }
        .onAppear {
            self.dataSource.loadCommentsFor(dataSource.post.id)
        }
    }
    
    private var comments: some View {
        List {
            ForEach(Array(self.dataSource.comments.enumerated()), id: \.element.id) { pair in
                HStack {
                    CommentRowView(viewModel: CommentRowViewModel(comment: pair.element))
                }
                .onAppear {
                    if self.dataSource.comments.isLast(pair.element) {
                        self.dataSource.loadCommentsFor(dataSource.post.id)
                    }
                }
                
                if self.dataSource.isLoading && self.dataSource.comments.isLast(pair.element) {
                    ProgressView()
                }
            }
            .listRowInsets( EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10) )
        }
        .onAppear { UITableView.appearance().separatorStyle = .none }
        .background(Color.gray)
        .listStyle(PlainListStyle())
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "1", title: .dr, firstName: "John", lastName: "Dough", gender: .male, email: "annabel.somby@example.com", location: .init(street: "5th Avenue", city: "New York", state: "NY", country: "USA", timezone: "-8UTC"), dateOfBirth: "08.10.1960", registerDate: "10.05.2020", phone: "555-555-555", picture: "https://randomuser.me/api/portraits/women/35.jpg")
        let post = Post(text: "adult Labrador retriever", image: "https://img.dummyapi.io/photo-1564694202779-bc908c327862.jpg", likes: 3, link: "https://www.instagram.com/teddyosterblomphoto/", tags: ["snow", "ice", "mountain"], publishDate: "10.05.2020", owner: user)
        CommentsListView(dataSource: CommentsDataSource(post: post))
    }
}
