//
//  MeasureView.swift
//  BadProportionalStackViews
//
//  Created by Don Mag on 7/6/23.
//

import UIKit

class MeasureView: UIView {

	var axis: NSLayoutConstraint.Axis = .vertical { didSet { setNeedsLayout() } }
	var arrowHeadWidth: CGFloat = 8.0 { didSet { setNeedsLayout() } }
	var arrowHeadHeight: CGFloat = 8.0 { didSet { setNeedsLayout() } }
	var color: UIColor = .black { didSet {
		shapeLayer.strokeColor = color.cgColor
		mLabel.textColor = color
	}}
	
	let mLabel: UILabel = {
		let v = UILabel()
		v.font = .monospacedDigitSystemFont(ofSize: 12.0, weight: .light)
		v.textAlignment = .center
		return v
	}()
	
	lazy var shapeLayer: CAShapeLayer = self.layer as! CAShapeLayer
	override class var layerClass: AnyClass {
		return CAShapeLayer.self
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		shapeLayer.fillColor = nil
		shapeLayer.strokeColor = color.cgColor
		shapeLayer.lineWidth = 1
		mLabel.textColor = color
		mLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(mLabel)
		NSLayoutConstraint.activate([
			mLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
			mLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			mLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 4.0),
			mLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4.0),
			mLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -4.0),
			mLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4.0),
		])
	}
	override func layoutSubviews() {
		super.layoutSubviews()

		var pt1: CGPoint!
		var pt2: CGPoint!

		let pth = CGMutablePath()

		var dRect = bounds
		
		if axis == .vertical {
			
			mLabel.text = String(format: "%0.2f", bounds.height)
			
			dRect = bounds.insetBy(dx: 0.0, dy: 2.0)
			
			// start at top center
			pt1 = .init(x: dRect.midX, y: dRect.minY)
			pth.move(to: pt1)
			
			pt2 = pt1
			pt2.x -= arrowHeadWidth * 0.5
			pt2.y += arrowHeadHeight
			
			// top arrow-head left arm
			pth.addLine(to: pt2)
			
			// back to top center
			pth.move(to: pt1)
			
			pt2 = pt1
			pt2.x += arrowHeadWidth * 0.5
			pt2.y += arrowHeadHeight
			
			// top arrow-head right arm
			pth.addLine(to: pt2)
			
			// start at bottom center
			pt1 = .init(x: dRect.midX, y: dRect.maxY)
			pth.move(to: pt1)
			
			pt2 = pt1
			pt2.x -= arrowHeadWidth * 0.5
			pt2.y -= arrowHeadHeight
			
			// bottom arrow-head left arm
			pth.addLine(to: pt2)
			
			// back to bottom center
			pth.move(to: pt1)
			
			pt2 = pt1
			pt2.x += arrowHeadWidth * 0.5
			pt2.y -= arrowHeadHeight
			
			// bottom arrow-head right arm
			pth.addLine(to: pt2)
			
			if mLabel.frame.height + 8.0 < dRect.height {
				
				// back to top center
				pt1 = .init(x: dRect.midX, y: dRect.minY)
				pth.move(to: pt1)
				
				pt2 = pt1
				pt2.y = mLabel.frame.minY - 4.0
				
				// top arrow-head vertical body
				pth.addLine(to: pt2)
				
				// back to bottom center
				pt1 = .init(x: dRect.midX, y: dRect.maxY)
				pth.move(to: pt1)
				
				pt2 = pt1
				pt2.y = mLabel.frame.maxY + 4.0
				
				// bottom arrow-head vertical body
				pth.addLine(to: pt2)
				
			}

			dRect = bounds
			
			// top and bottom edge lines
			pt1 = .init(x: dRect.minX, y: dRect.minY)
			pt2 = .init(x: dRect.maxX, y: dRect.minY)
			pth.move(to: pt1)
			pth.addLine(to: pt2)
			
			pt1 = .init(x: dRect.minX, y: dRect.maxY)
			pt2 = .init(x: dRect.maxX, y: dRect.maxY)
			pth.move(to: pt1)
			pth.addLine(to: pt2)
			
		} else {
			
			mLabel.text = String(format: "%0.2f", bounds.width)
			
			dRect = bounds.insetBy(dx: 2.0, dy: 0.0)
			
			// left arrow-head
			pt1 = .init(x: dRect.minX + arrowHeadWidth, y: dRect.midY - arrowHeadHeight * 0.5)
			pth.move(to: pt1)
			
			pt2 = .init(x: dRect.minX, y: dRect.midY)
			pth.addLine(to: pt2)
			pt2 = .init(x: dRect.minX + arrowHeadWidth, y: dRect.midY + arrowHeadHeight * 0.5)
			pth.addLine(to: pt2)
			
			// start at right middle
			pt1 = .init(x: dRect.maxX, y: dRect.midY)
			pth.move(to: pt1)
			
			pt2 = pt1
			pt2.x -= arrowHeadWidth
			pt2.y -= arrowHeadHeight * 0.5
			
			// bottom arrow-head left arm
			pth.addLine(to: pt2)
			
			// back to bottom center
			pth.move(to: pt1)
			
			pt2 = pt1
			pt2.x -= arrowHeadWidth
			pt2.y += arrowHeadHeight * 0.5
			
			// bottom arrow-head right arm
			pth.addLine(to: pt2)
			
			if mLabel.frame.width + 8.0 < dRect.width {
				
				// back to top center
				pt1 = .init(x: dRect.minX, y: dRect.midY)
				pth.move(to: pt1)
				
				pt2 = pt1
				pt2.x = mLabel.frame.minX - 4.0
				
				// top arrow-head vertical body
				pth.addLine(to: pt2)
				
				// back to bottom center
				pt1 = .init(x: dRect.maxX, y: dRect.midY)
				pth.move(to: pt1)
				
				pt2 = pt1
				pt2.x = mLabel.frame.maxX + 4.0
				
				// bottom arrow-head vertical body
				pth.addLine(to: pt2)
				
			}
			
			dRect = bounds
			
			// left and right edge lines
			pt1 = .init(x: dRect.minX, y: dRect.minY)
			pt2 = .init(x: dRect.minX, y: dRect.maxY)
			pth.move(to: pt1)
			pth.addLine(to: pt2)
			
			pt1 = .init(x: dRect.maxX, y: dRect.minY)
			pt2 = .init(x: dRect.maxX, y: dRect.maxY)
			pth.move(to: pt1)
			pth.addLine(to: pt2)
			
		}
		
		shapeLayer.path = pth
		
	}

}
