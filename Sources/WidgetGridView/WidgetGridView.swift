
import SwiftUI

public struct WidgetGridViewCongif {

    public init() {
        
    }
    
    public static let `default` = WidgetGridViewCongif()
}

public struct WidgetGridView: View {
    
    @State var grid: WGGridModel
    @State private var isDragging = false
    @State private var canEdit = false
//    @State private var error = ""
//    @State private var clickedCell = ""
//    @State private var selectedWidget: WGWidgetModel
    
    public var body: some View {
//        VStack {
//            Color.red
//                .frame(selectedWidget.size.getSize())
//            HStack {
//                Button(action: {
//                    self.selectedWidget = testingWidgets[0]
//                }) {
//                    testingWidgets[0].size.getView()
//                }
//                Button(action: {
//                    self.selectedWidget = testingWidgets[1]
//                }) {
//                    testingWidgets[1].size.getView()
//                }
//                Button(action: {
//                    self.selectedWidget = testingWidgets[2]
//                }) {
//                    testingWidgets[2].size.getView()
//                }
//                Button(action: {
//                    self.selectedWidget = testingWidgets[3]
//                }) {
//                    testingWidgets[3].size.getView()
//                }
//            }
            ZStack(alignment: .topLeading) {
                LazyVGrid(columns: grid.columnsForGird, alignment: .center, spacing: grid.size.getPadding()) {
                    ForEach(grid.cells) { thisCell in
                        ZStack {
                            Button(action: {
//                                    self.clickedCell = "\(thisCell.id)"
                                do {
                                    try grid.addWidget(WGWidgetModel(WGSize(2, 2, with: grid.size), type: ""), at: thisCell.id)
//                                    self.error = ""
                                } catch {
//                                    self.error = "\(error)"
                                    print(error)
                                }
                            }) {
                                Color.green
                                    .frame(grid.size.getSize(for: 1))
                            }
                        }
                    }
                }
        //        .frame(width: 360.0)
//                .toolbar {
//                    ToolbarItem(placement: .bottomBar) {
//                        VStack {
//                            Text(error)
//                            Text(clickedCell)
//                        }
//                    }
//                }
                ForEach(grid.widgets) { widget in
                    if let thisCell = grid.cells.first(where: { $0.data == widget }) {
                        ZStack {
                            Color.blue
                                .frame(widget.size.getSize())
                        }
                        .padding(thisCell.id, with: widget.size)
                    }
                }
            }
            .frame(width: grid.size.getSize().width)
        }
//    }
    
    public init(_ grid: WGGridModel) {
        _grid = State(initialValue: grid)
//        _selectedWidget = State(initialValue: WGWidgetModel(WGSize(1, 1, with: grid.size), type: ""))
    }
    
    public init(_ size: WGSize) {
        self.init(WGGridModel(size))
    }
}

struct WidgetGridView_Preview: PreviewProvider {
    static var previews: some View {
        if #available(iOSApplicationExtension 15.0, *) {
            GeometryReader { geo in
                WidgetGridView(WGGridModel(WGSize(2, 3, multiplier: 30, padding: 0, with: geo, for: .width)))
            }
            .previewInterfaceOrientation(.landscapeRight)
        } else {
            // Fallback on earlier versions
        }
    }
}

private let testingGrid = WGGridModel(WGSize(12, 3, multiplier: 30, padding: 1))

private let testingWidgets = [
    WGWidgetModel(WGSize(1, 1, with: testingGrid.size), type: ""),
    WGWidgetModel(WGSize(3, 1, with: testingGrid.size), type: ""),
    WGWidgetModel(WGSize(4, 2, with: testingGrid.size), type: ""),
    WGWidgetModel(WGSize(1, 3, with: testingGrid.size), type: ""),
]
