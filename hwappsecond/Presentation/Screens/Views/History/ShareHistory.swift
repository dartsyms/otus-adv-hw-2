//
//  ShareHistory.swift
//  hwappsecond
//

import SwiftUI
import CoreData

struct ShareHistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel = HistoryViewModel()
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)]) var sharedItems: FetchedResults<Item>
    
    @State private var searchStr: String = ""
    @State private var showTest: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                self.header
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                Divider()
                    .sheet(isPresented: $showTest) {
                        showTest = false
                    } content: {
                        self.dataStructures
                    }

                self.rows
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
            .navigationBarItems(
                leading: Button(action: { showTest.toggle() }, label: { Text("Sheet") }),
                trailing: Button(action: { viewModel.suffixesCreationTest() }) { Text("Test") })
            .navigationBarTitle("Share History", displayMode: .inline)
        }
            
    }
    
    private var header: some View {
        HStack {
            Text("Content")
                .font(.system(size: 10))
                .frame(width: UIScreen.main.bounds.width/2, height: 25, alignment: .center)
            Text("Datetime")
                .font(.system(size: 10))
                .frame(width: UIScreen.main.bounds.width/4, height: 25, alignment: .center)
            Text("Creation time")
                .font(.system(size: 10))
                .frame(width: UIScreen.main.bounds.width/4, height: 25, alignment: .center)
        }
    }
    
    private var rows: some View {
        ScrollView {
            LazyVStack {
                ForEach(sharedItems.sorted { $0.timestamp! > $1.timestamp! }, id: \.id) { item in
                    HStack {
                        Text("\(item.content?.prefix(30).lowercased() ?? "")...")
                            .lineLimit(1)
                            .font(.system(size: 10))
                            .foregroundColor(.primary)
                            .frame(width: UIScreen.main.bounds.width/2, height: 25, alignment: .trailing)
                        Divider()
                        Text("\((item.timestamp ?? Date()).formatted)")
                            .lineLimit(1)
                            .font(.system(size: 10))
                            .foregroundColor(.primary)
                            .frame(width: UIScreen.main.bounds.width/4, height: 25, alignment: .center)
                        Divider()
                        Text("\(item.id != nil ? (viewModel.timesDictForSuffixes[item.id!.uuidString] ?? 0.0) : 0.0)")
                            .font(.system(size: 10))
                            .background(colorFor(value: viewModel.timesDictForSuffixes[item.id!.uuidString] ?? 0.0))
                            .frame(width: UIScreen.main.bounds.width/4, height: 25, alignment: .leading)
                    }
                }
            }
        }
    }
    
    private func colorFor(value: Double) -> Color {
        guard let redVal = viewModel.timesDictForSuffixes.values.max(),
              let greenVal = viewModel.timesDictForSuffixes.values.min(), value > 0 else { return Color(.clear) }
        if value == redVal { return Color.init(.sRGB, red: 255.0, green: 0, blue: 0, opacity: 1) }
        if value == greenVal { return Color.init(.sRGB, red: 0, green: 255.0, blue: 0, opacity: 1) }
        let lhsColor = UIColor.init(red: CGFloat(value/redVal * 255.0), green: 0, blue: 0, alpha: CGFloat(value/redVal))
        let rhsColor = UIColor.init(red: 0, green: CGFloat(greenVal/value * 255.0), blue: 0, alpha: CGFloat(greenVal/value))
        return Color(lhsColor + rhsColor)
    }
    
    private var dataStructures: some View {
        VStack {
            HStack {
                Text("Data structures create test")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                Spacer()
                Button {
                    viewModel.dataStructuresCreationTest(for: 10000, and: sharedItems.randomElement()?.content ?? "")
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle")
                }
                .padding(.trailing, 20)
            }
            .padding(.top, 20)
            Divider()
                .padding(.vertical, 10)
            HStack {
                Text("Array: ")
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                Spacer()
                Text("\(viewModel.timesDict["Array"] ?? 0.0)")
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
            }
            .padding()
            HStack {
                Text("Dictionary: ")
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                Spacer()
                Text("\(viewModel.timesDict["Dictionary"] ?? 0.0)")
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
            }
            .padding()
            HStack {
                Text("Set: ")
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                Spacer()
                Text("\(viewModel.timesDict["Set"] ?? 0.0)")
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
            }
            .padding()
            HStack {
                Text("SuffixArray: ")
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                Spacer()
                Text("\(viewModel.timesDict["SuffixArray"] ?? 0.0)")
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
            }
            .padding()
            Spacer()
        }
    }
}

struct ShareHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ShareHistoryView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

