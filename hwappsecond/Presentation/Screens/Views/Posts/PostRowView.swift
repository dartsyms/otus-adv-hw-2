//
//  PostRowView.swift
//  hwappsecond
//

import SwiftUI
import DummyApiNetworkClient

struct PostRowView: View {
    @ObservedObject var viewModel: PostRowViewModel
    
    init(viewModel: PostRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let url = URL(string: self.viewModel.post.image ?? "https://img.dummyapi.io/photo-1510414696678-2415ad8474aa.jpg")!
        HStack {
            VStack {
                AsyncImage(url: url, placeholder: { Image(systemName: "photo") }, image: { Image(uiImage: $0).resizable() })
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 10) {
                            ForEach(Array(viewModel.post.tags!.enumerated()), id: \.element) { pair in
                                Text(pair.element)
                                    .lineLimit(1)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .padding(4)
                                    .background(Capsule().stroke())
                            }
                        }
                        .padding(.bottom, 4)
                        Text(self.viewModel.titled(self.viewModel.post))
                            .font(.headline)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                        Text(self.viewModel.writtenBy(self.viewModel.post.owner))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 1)
                    }
                    .layoutPriority(100)
                    Spacer()
                }
                .padding()
            }
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1))
            .padding([.top, .horizontal])
            
            // MARK: -  Custom navigation
            Spacer()
            NavPushButton(destination: PostDetailsView(post: viewModel.post)) {}
            Spacer()
        }
    }
    
//    private func writtenBy(_ author: User?) -> String {
//        guard author != nil else { return "Unknown Author" }
//        return "by \(author?.firstName ?? "John") \(author?.lastName ?? "Dough")"
//    }
//
//    private func titled(_ post: Post?) -> String {
//        guard let title = post?.text else { return "No title" }
//        return title.capitalized
//    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "1", title: .dr, firstName: "John", lastName: "Dough", gender: .male, email: "emilie.lambert@example.com", location: .init(street: "5th Avenue", city: "New York", state: "NY", country: "USA", timezone: "-8UTC"), dateOfBirth: "08.10.1960", registerDate: "10.05.2020", phone: "555-555-555", picture: "https://randomuser.me/api/portraits/men/80.jpg")
        let post = Post(text: "adult Labrador retriever", image: "https://img.dummyapi.io/photo-1564694202779-bc908c327862.jpg", likes: 3, link: "https://www.instagram.com/teddyosterblomphoto/", tags: ["snow", "ice", "mountain"], publishDate: "10.05.2020", owner: user)
        PostRowView(viewModel: PostRowViewModel(post: post))
    }
}
