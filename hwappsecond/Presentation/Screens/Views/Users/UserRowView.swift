//
//  UserRowView.swift
//  hwappsecond
//

import SwiftUI
import DummyApiNetworkClient
import AsyncImageLoader

struct UserRowView: View {
    @ObservedObject var viewModel: UserRowViewModel
    
    init(viewModel: UserRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let url = URL(string: viewModel.user.picture ?? "https://randomuser.me/api/portraits/men/80.jpg")!
        NavigationLink(destination: UserDetailsView(person: viewModel.user)) {
            HStack(alignment: .center) {
                AsyncImage(url: url, placeholder: { Image(systemName: "photo") }, image: { Image(uiImage: $0).resizable() })
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .padding(.all, 10)
                
                VStack(alignment: .leading) {
                    Text(viewModel.fullName)
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    Text(viewModel.user.email ?? "")
                        .font(.system(size: 12, weight: .bold, design: .default))
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                    HStack {
                        Text(viewModel.user.phone ?? "")
                            .font(.system(size: 14, weight: .bold, design: .default))
                            .foregroundColor(.primary)
                            .padding(.top, 8)
                    }
                }.padding(.trailing, 20)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.white)
            .modifier(CardModifier())
            .padding(.all, 1)
        }
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
    
}

struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        let user = CachedUser(userId: "1", title: "Dr.", firstName: "John", lastName: "Dough", gender: "male", email: "someone@nowhere.net", location: .init(street: "5th Avenue", city: "New York", state: "NY", country: "USA", timezone: "-8UTC"), dateOfBirth: "08.10.1960", registerDate: "10.05.2020", phone: "555-555-555", picture: "https://randomuser.me/api/portraits/men/80.jpg")
        UserRowView(viewModel: UserRowViewModel(user: user))
    }
}
