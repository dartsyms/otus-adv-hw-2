//
//  UserDetailsView.swift
//  hwappsecond
//

import SwiftUI
import CoreLocation
import DummyApiNetworkClient

struct UserDetailsView: View {
    @ObservedObject private var viewModel = UserViewModel()
    
    var person: User
    var openedFromPost: Bool = false
    
    init(person: User, fromPost: Bool = false) {
        self.person = person
        self.openedFromPost = fromPost
    }
    
    var body: some View {
        let url = URL(string: person.picture ?? "https://randomuser.me/api/portraits/men/80.jpg")!
        VStack {
            MapView(coordinate: viewModel.location ?? CLLocationCoordinate2D(latitude: -31.9535701, longitude: 115.8569784))
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)
            
            AsyncImage(url: url, placeholder: { Image(systemName: "photo")}, image: { Image(uiImage: $0).resizable() })
                .clipShape(Circle())
                .frame(width: 210, height: 210)
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.user?.title?.rawValue ?? "")
                        .font(.title)
                    Text(viewModel.user?.firstName ?? "")
                        .font(.title)
                    Text(viewModel.user?.lastName ?? "")
                        .font(.title)
                }
                Text(viewModel.userOrigin)
                    .font(.caption)
                    .padding(.bottom)
                HStack(alignment: .top) {
                    Text(viewModel.email)
                        .font(.subheadline)
                }
                HStack(alignment: .top) {
                    Text(viewModel.phone)
                        .font(.subheadline)
                }
                Spacer()
                if openedFromPost {
                    NavPopButton(destination: .root) {
                        Text("Get back to posts")
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        
        .onAppear {
            if let id = person.id {
                self.viewModel.loadDetailsFor(id)
            }
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "1", title: .dr, firstName: "John", lastName: "Dough", gender: .male, email: "", location: .init(street: "5th Avenue", city: "New York", state: "NY", country: "USA", timezone: "-8UTC"), dateOfBirth: "08.10.1960", registerDate: "10.05.2020", phone: "555-555-555", picture: "")
        UserDetailsView(person: user)
    }
}
