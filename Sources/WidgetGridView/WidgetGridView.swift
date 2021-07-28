
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
                                .frame(thisCell.data!.size)
                        }
                    }
                }
            }
        }
    }
    
    public init(_ size: WGSize) {
        _grid = State(initialValue: WGGridModel(size))
    }
}
