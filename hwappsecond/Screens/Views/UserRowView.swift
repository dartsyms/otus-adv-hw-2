//
//  UserRowView.swift
//  hwappsecond
//

import SwiftUI

struct UserRowView: View {
    @ObservedObject var viewModel: UserRowViewModel
    
    init(viewModel: UserRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationLink(destination: UserDetailsView(person: viewModel.user)) {
            Text("\(viewModel.user.firstName ?? "") \(viewModel.user.lastName ?? "")")
        }
    }
}

struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "1", title: .dr, firstName: "John", lastName: "Dough", gender: .male, email: "", location: .init(street: "5th Avenue", city: "New York", state: "NY", country: "USA", timezone: "-8UTC"), dateOfBirth: "08.10.1960", registerDate: "10.05.2020", phone: "555-555-555", picture: "")
        UserRowView(viewModel: UserRowViewModel(user: user))
    }
}
