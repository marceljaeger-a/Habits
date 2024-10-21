//
//  TimeProposalPicker.swift
//  Habits
//
//  Created by Marcel Jäger on 28.09.24.
//

import Foundation
import SwiftUI

struct TimeProposalMenu: View {
    var body: some View {
        TimeProposalMenuLayout {
            Button(action: { setTime(hour: 6) }) {
                Text("6:00")
                    .frame(maxWidth: .infinity)
            }
    
            Button(action: { setTime(hour: 9) }) {
                Text("9:00")
                    .frame(maxWidth: .infinity)
            }
    
            Button(action: { setTime(hour: 18) }) {
                Text("18:00")
                    .frame(maxWidth: .infinity)
            }
      
            Button(action: { setTime(hour: 21) }) {
                Text("21:00")
                    .frame(maxWidth: .infinity)
            }
        }
        .fixedSize()
        .buttonStyle(.bordered)
        .buttonBorderShape(.roundedRectangle)
    }
    
    @Binding var value: Date
    
    private func setTime(hour: Int, minute: Int = 0, second: Int = 0) {
        let newTime = Calendar.current.date(bySettingHour: hour, minute: minute, second: second, of: value)
        guard let newTime else { return }
        value = newTime
    }
}

private struct TimeProposalMenuLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = getHighestWidth(in: subviews, proposal: proposal)
        let height = getHighestHeight(in: subviews, proposal: proposal)
        var spacing: Double = 0
        getHorizontalSpacingLengths(of: subviews).forEach { spacing += $0 }
        
        return CGSize(width: width * Double(subviews.count) + spacing, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let highestWidth = getHighestWidth(in: subviews, proposal: proposal)
        let highestHeight = getHighestHeight(in: subviews, proposal: proposal)
        
        var nextPosition = CGPoint(x: bounds.minX + highestWidth/2, y: bounds.minY + highestHeight/2)
        var previousSubview: Subviews.Element? = nil
        for subview in subviews {
            if let previousSubview {
                let spacing = subview.spacing.distance(to: previousSubview.spacing, along: .horizontal)
                nextPosition.x += (spacing) + highestWidth
            }
            subview.place(at: nextPosition, anchor: .center, proposal: .init(width: highestWidth, height: highestHeight))
            previousSubview = subview
        }
    }
    
    private func getHighestHeight(in subviews: Subviews, proposal: ProposedViewSize) -> Double {
        var height = 0.0
        for subview in subviews {
            let size = subview.sizeThatFits(proposal)
            if height < size.height {
                height = size.height
            }
        }
        return height
    }
    
    private func getHighestWidth(in subviews: Subviews, proposal: ProposedViewSize) -> Double {
        var width = 0.0
        for subview in subviews {
            let size = subview.sizeThatFits(proposal)
            if width < size.width {
                width = size.width
            }
        }
        return width
    }
    
    private func getHorizontalSpacingLengths(of subviews: Subviews) -> [CGFloat] {
        var spacings: [CGFloat] = []
        var previousSpacing: ViewSpacing? = nil
        for subview in subviews {
            if let previousSpacing {
                let spacingLength = subview.spacing.distance(to: previousSpacing, along: .horizontal)
                spacings.append(spacingLength)
            }
            previousSpacing = subview.spacing
        }
        return spacings
    }
}
