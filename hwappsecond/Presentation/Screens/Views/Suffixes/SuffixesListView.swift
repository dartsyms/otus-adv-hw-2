//
//  SuffixesListView.swift
//  hwappsecond
//

import SwiftUI

struct SuffixesListView: View {
    @ObservedObject var dataSource: SuffixesDataSource
    @ObservedObject var dataUpdater: ShareDataUpdate
    
    @State private var searchStr: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                self.search
                self.switcher
                
                self.sortingChanger.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 10))
                if dataSource.switcher != .all {
                    self.topRows
                } else if dataSource.switcher == .all && dataSource.sortToggle == .asc {
                    self.incRows
                } else if dataSource.switcher == .all && dataSource.sortToggle == .desc {
                    self.decRows
                }
            }
            .onAppear {
                updateSourceData()
            }
            .onReceive(NotificationCenter.default.publisher(for: .NSExtensionHostDidBecomeActive)) { _ in
                updateSourceData()
            }
            .onReceive(dataUpdater.notifier) { newData in
                if newData {
                    updateSourceData()
                }
            }
            .navigationBarTitle("Suffixes", displayMode: .inline)
        }
            
    }
    
    private func updateSourceData() {
        if let defaults = UserDefaults(suiteName: "group.ru.it.kot.hwappsecond"),
           let res = defaults.string(forKey: "copied_text") {
            dataSource.updateSource(data: res)
        }
    }
    
    private var search: some View {
        HStack {
            CustomSearchView(query: $searchStr)
                .onChange(of: searchStr) { str in
                    dataSource.term = str
                    if searchStr.isEmpty {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dataSource.sortByKeys(type: .asc)
                        }
                    }
                }
        }
        .padding(.top, 16)
    }
    
    private var sortingChanger: some View {
        Toggle(isOn: Binding<Bool>(get: { dataSource.sortToggle == .asc && dataSource.switcher == .all },
                                   set: { turnedOn in dataSource.sortToggle = turnedOn && dataSource.switcher == .all ? .asc : .desc})) {
            Text("\(dataSource.sortToggle == .asc ? "ASC" : "DESC")").padding(.horizontal, 20) }
    }
    
    private var switcher: some View {
        Picker(selection: $dataSource.switcher, label: Text("")) {
            Text("All").tag(PickerState.all)
            Text("Top 10 3x").tag(PickerState.top3s)
            Text("Top 10 5x").tag(PickerState.top5s)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private var topRows: some View {
        List {
            ForEach(dataSource.tops, id: \.self.0) { pair in
                HStack {
                    Text("\(pair.0) [\(pair.1) \(pair.1 == 1 ? "time": "times")]")
                        .lineLimit(1)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
        }
    }
    
    private var incRows: some View {
        List {
            ForEach(Array(dataSource.suffixes.keys.sorted(by: <)), id: \.self) { key in
                HStack {
                    Text("\(key) [\(dataSource.suffixes[key] ?? 0) \(dataSource.suffixes[key] ?? 0 == 1 ? "time": "times")]")
                        .lineLimit(1)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
        }
    }
    
    private var decRows: some View {
        List {
            ForEach(Array(dataSource.suffixes.keys.sorted(by: >)), id: \.self) { key in
                HStack {
                    HStack {
                        Text("\(key) [\(dataSource.suffixes[key] ?? 0) \(dataSource.suffixes[key] == 1 ? "time": "times")]")
                            .lineLimit(1)
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

struct SuffixesListView_Previews: PreviewProvider {
    static var previews: some View {
        SuffixesListView(dataSource: SuffixesDataSource(source: "sssss"), dataUpdater: ShareDataUpdate())
    }
}
