
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
    
    public var body: some View {
        LazyVGrid(columns: grid.columnsForGird, spacing: grid.size.getPadding()) {
            ForEach(grid.cells) { thisCell in
                ZStack {
                    Button(action: {
                        do {
                            try grid.addWidget(WGWidgetModel(WGSize(1), type: "com.zrapata.schoolendar.widget.school"), at: thisCell.id)
                        } catch {
                            print(error)
                        }
                    }) {
                        if thisCell.isStart {
                            Color.blue
                                .frame(thisCell.data!.size.getSize())
                        } else {
                            Color.green
                                .frame(grid.size.getSize(for: 1))
                        }
                    }
                }
            }
        }
        .frame(grid.size.getSize())
    }
    
    public init(_ grid: WGGridModel) {
        _grid = State(initialValue: grid)
    }
    
    public init(_ size: WGSize) {
        self.init(WGGridModel(size))
    }
}

struct WidgetGridView_Preview: PreviewProvider {
    static var previews: some View {
        WidgetGridView(testingGrid)
            
    }
}

private let testingGrid = WGGridModel(2)
