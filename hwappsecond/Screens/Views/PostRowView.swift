//
//  PostRowView.swift
//  hwappsecond
//

import SwiftUI

struct PostRowView: View {
    @ObservedObject var viewModel: PostRowViewModel
    
    init(viewModel: PostRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text(viewModel.post.text ?? "")
    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
//        let tags = [Tag(title: "tag1"), Tag(title: "tag2"), Tag(title: "tag3"), Tag(title: "tag4")]
        let user = User(id: "1", title: .dr, firstName: "John", lastName: "Dough", gender: .male, email: "", location: .init(street: "5th Avenue", city: "New York", state: "NY", country: "USA", timezone: "-8UTC"), dateOfBirth: "08.10.1960", registerDate: "10.05.2020", phone: "555-555-555", picture: "")
        let post = Post(text: "Some text", image: "", likes: 3, link: "", tags: nil, publishDate: "10.05.2020", owner: user)
        PostRowView(viewModel: PostRowViewModel(post: post))
    }
}
