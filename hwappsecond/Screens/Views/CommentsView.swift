//
//  CommentsView.swift
//  hwappsecond
//

import SwiftUI

struct CommentsView: View {
    var comment: Comment
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "1", title: .dr, firstName: "John", lastName: "Dough", gender: .male, email: "", location: .init(street: "5th Avenue", city: "New York", state: "NY", country: "USA", timezone: "-8UTC"), dateOfBirth: "08.10.1960", registerDate: "10.05.2020", phone: "555-555-555", picture: "")
        CommentsView(comment: Comment(id: "1", message: "Some message", owner: user, publishDate: "10.05.2020"))
    }
}
