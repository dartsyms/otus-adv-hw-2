//
//  CustomSearchView.swift
//  hwappsecond
//

import SwiftUI

struct CustomSearchView: View {
    @Binding var query: String
    @State private var showCancelButton: Bool = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("Search...", text: $query, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    
                })
                .foregroundColor(.primary)
                
                Button(action: {
                    $query.wrappedValue = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity($query.wrappedValue == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)

            if showCancelButton  {
                Button("Cancel") {
                    UIApplication.shared.endFieldEditing(true)
                    $query.wrappedValue = ""
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(.horizontal)
    }
}

struct CustomSearchView_Previews: PreviewProvider {
    static var previews: some View {
        CustomSearchView(query: .constant("Search..."))
    }
}

