//
//  MeasureView.swift
//  BadProportionalStackViews
//
//  Created by Don Mag on 7/6/23.
//

import UIKit

class aMeasureView: UIView {

	public var axis: NSLayoutConstraint.Axis = .vertical { didSet { setNeedsLayout() } }
	public var arrowHeadWidth: CGFloat = 8.0 { didSet { setNeedsLayout() } }
	public var arrowHeadHeight: CGFloat = 8.0 { didSet { setNeedsLayout() } }
	public var color: UIColor = .black { didSet {
		shapeLayer.strokeColor = color.cgColor
		mLabel.textColor = color
	}}
	
	private let mLabel: UILabel = {
		let v = UILabel()
		v.font = .monospacedDigitSystemFont(ofSize: 12.0, weight: .light)
		v.textAlignment = .center
		return v
	}()
	
	override class var layerClass: AnyClass { CAShapeLayer.self }
	private var shapeLayer: CAShapeLayer { layer as! CAShapeLayer }
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {
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
		let pth = CGMutablePath()

		var dRect = bounds
		
		if axis == .vertical {
			
			mLabel.text = String(format: "%0.2f", bounds.height)
			
			dRect = bounds.insetBy(dx: 0.0, dy: 2.0)
			
			// top arrow-head
			pt1 = .init(x: dRect.midX - arrowHeadWidth * 0.5, y: dRect.minY + arrowHeadHeight)
			pth.move(to: pt1)

			pt1 = .init(x: dRect.midX, y: dRect.minY)
			pth.addLine(to: pt1)
			pt1 = .init(x: dRect.midX + arrowHeadWidth * 0.5, y: dRect.minY + arrowHeadHeight)
			pth.addLine(to: pt1)

			// bottom arrow-head
			pt1 = .init(x: dRect.midX - arrowHeadWidth * 0.5, y: dRect.maxY - arrowHeadHeight)
			pth.move(to: pt1)
			
			pt1 = .init(x: dRect.midX, y: dRect.maxY)
			pth.addLine(to: pt1)
			pt1 = .init(x: dRect.midX + arrowHeadWidth * 0.5, y: dRect.maxY - arrowHeadHeight)
			pth.addLine(to: pt1)
			
			if mLabel.frame.height + 8.0 < dRect.height {
				
				// top center
				pt1 = .init(x: dRect.midX, y: dRect.minY)
				pth.move(to: pt1)
				pt1.y = mLabel.frame.minY - 4.0
				pth.addLine(to: pt1)
				
				// bottom center
				pt1 = .init(x: dRect.midX, y: dRect.maxY)
				pth.move(to: pt1)
				pt1.y = mLabel.frame.maxY + 4.0
				pth.addLine(to: pt1)
				
			}

			dRect = bounds
			
			// top and bottom edge lines
			pt1 = .init(x: dRect.minX, y: dRect.minY)
			pth.move(to: pt1)
			pt1.x = dRect.maxX
			pth.addLine(to: pt1)
			
			pt1 = .init(x: dRect.minX, y: dRect.maxY)
			pth.move(to: pt1)
			pt1.x = dRect.maxX
			pth.addLine(to: pt1)

		} else {
			
			mLabel.text = String(format: "%0.2f", bounds.width)
			
			dRect = bounds.insetBy(dx: 2.0, dy: 0.0)
			
			// left arrow-head
			pt1 = .init(x: dRect.minX + arrowHeadWidth, y: dRect.midY - arrowHeadHeight * 0.5)
			pth.move(to: pt1)
			
			pt1 = .init(x: dRect.minX, y: dRect.midY)
			pth.addLine(to: pt1)
			pt1 = .init(x: dRect.minX + arrowHeadWidth, y: dRect.midY + arrowHeadHeight * 0.5)
			pth.addLine(to: pt1)

			// right arrow-head
			pt1 = .init(x: dRect.maxX - arrowHeadWidth, y: dRect.midY - arrowHeadHeight * 0.5)
			pth.move(to: pt1)
			
			pt1 = .init(x: dRect.maxX, y: dRect.midY)
			pth.addLine(to: pt1)
			pt1 = .init(x: dRect.maxX - arrowHeadWidth, y: dRect.midY + arrowHeadHeight * 0.5)
			pth.addLine(to: pt1)
			
			if mLabel.frame.width + 8.0 < dRect.width {
				
				// left middle
				pt1 = .init(x: dRect.minX, y: dRect.midY)
				pth.move(to: pt1)
				pt1.x = mLabel.frame.minX - 4.0
				pth.addLine(to: pt1)
				
				// right middle
				pt1 = .init(x: dRect.maxX, y: dRect.midY)
				pth.move(to: pt1)
				pt1.x = mLabel.frame.maxX + 4.0
				pth.addLine(to: pt1)
				
			}
			
			dRect = bounds
			
			// left and right edge lines
			pt1 = .init(x: dRect.minX, y: dRect.minY)
			pth.move(to: pt1)
			pt1.y = dRect.maxY
			pth.addLine(to: pt1)
			
			pt1 = .init(x: dRect.maxX, y: dRect.minY)
			pth.move(to: pt1)
			pt1.y = dRect.maxY
			pth.addLine(to: pt1)
			
		}
		
		shapeLayer.path = pth
		
	}

}

class MeasureView: UIView {
	
	public var axis: NSLayoutConstraint.Axis = .vertical { didSet { setNeedsLayout() } }
	public var arrowHeadWidth: CGFloat = 6.0 { didSet { setNeedsLayout() } }
	public var arrowHeadHeight: CGFloat = 8.0 { didSet { setNeedsLayout() } }
	public var color: UIColor = .black { didSet {
		shapeLayer.strokeColor = color.cgColor
		mLabel.textColor = color
	}}
	
	private let mLabel: UILabel = {
		let v = UILabel()
		v.font = .monospacedDigitSystemFont(ofSize: 12.0, weight: .light)
		v.textAlignment = .center
		return v
	}()
 
	override class var layerClass: AnyClass { CAShapeLayer.self }
	private var shapeLayer: CAShapeLayer { layer as! CAShapeLayer }
	
	override var intrinsicContentSize: CGSize {
		return .init(width: 100.0, height: 16.0 + mLabel.intrinsicContentSize.height + 4.0 + 4.0 + 8.0)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {
		shapeLayer.fillColor = nil
		shapeLayer.strokeColor = color.cgColor
		shapeLayer.lineWidth = 1
		mLabel.textColor = color
		mLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(mLabel)
		NSLayoutConstraint.activate([
			mLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
			//mLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			mLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.0),
//			mLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 4.0),
//			mLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4.0),
//			mLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -4.0),
//			mLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4.0),
		])
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		
		var pt1: CGPoint!
		let pth = CGMutablePath()
		
		var dRect = bounds
		
		if axis == .vertical {
			
			mLabel.text = String(format: "%0.2f", bounds.height)
			
			dRect = bounds.insetBy(dx: 0.0, dy: 2.0)
			
			// top arrow-head
			pt1 = .init(x: dRect.midX - arrowHeadWidth * 0.5, y: dRect.minY + arrowHeadHeight)
			pth.move(to: pt1)
			
			pt1 = .init(x: dRect.midX, y: dRect.minY)
			pth.addLine(to: pt1)
			pt1 = .init(x: dRect.midX + arrowHeadWidth * 0.5, y: dRect.minY + arrowHeadHeight)
			pth.addLine(to: pt1)
			
			// bottom arrow-head
			pt1 = .init(x: dRect.midX - arrowHeadWidth * 0.5, y: dRect.maxY - arrowHeadHeight)
			pth.move(to: pt1)
			
			pt1 = .init(x: dRect.midX, y: dRect.maxY)
			pth.addLine(to: pt1)
			pt1 = .init(x: dRect.midX + arrowHeadWidth * 0.5, y: dRect.maxY - arrowHeadHeight)
			pth.addLine(to: pt1)
			
			if mLabel.frame.height + 8.0 < dRect.height {
				
				// top center
				pt1 = .init(x: dRect.midX, y: dRect.minY)
				pth.move(to: pt1)
				pt1.y = mLabel.frame.minY - 4.0
				pth.addLine(to: pt1)
				
				// bottom center
				pt1 = .init(x: dRect.midX, y: dRect.maxY)
				pth.move(to: pt1)
				pt1.y = mLabel.frame.maxY + 4.0
				pth.addLine(to: pt1)
				
			}
			
			dRect = bounds
			
			// top and bottom edge lines
			pt1 = .init(x: dRect.minX, y: dRect.minY)
			pth.move(to: pt1)
			pt1.x = dRect.maxX
			pth.addLine(to: pt1)
			
			pt1 = .init(x: dRect.minX, y: dRect.maxY)
			pth.move(to: pt1)
			pt1.x = dRect.maxX
			pth.addLine(to: pt1)
			
		} else {
			
			if self.bounds.width <= 0.0 {
				return
			}
			
			mLabel.text = String(format: "%0.2f", bounds.width)
			
			dRect = bounds.insetBy(dx: 2.0, dy: 0.0)
			dRect.size.height = bounds.height - (mLabel.frame.height + 0.0)
			
			// left arrow-head
			pt1 = .init(x: dRect.minX + arrowHeadWidth, y: dRect.midY - arrowHeadHeight * 0.5)
			pth.move(to: pt1)

			pt1 = .init(x: dRect.minX, y: dRect.midY)
			pth.addLine(to: pt1)

			pt1 = .init(x: dRect.minX + arrowHeadWidth, y: dRect.midY + arrowHeadHeight * 0.5)
			pth.addLine(to: pt1)
			
			// right arrow-head
			pt1 = .init(x: dRect.maxX - arrowHeadWidth, y: dRect.midY - arrowHeadHeight * 0.5)
			pth.move(to: pt1)
			
			pt1 = .init(x: dRect.maxX, y: dRect.midY)
			pth.addLine(to: pt1)

			pt1 = .init(x: dRect.maxX - arrowHeadWidth, y: dRect.midY + arrowHeadHeight * 0.5)
			pth.addLine(to: pt1)
			
			var gap = dRect.width - (arrowHeadWidth * 2.0 + 8.0)
			if gap < 8.0 {
				// center line
				pt1 = .init(x: dRect.minX, y: dRect.midY)
				pt1.x = dRect.midX - 4.0
				pth.move(to: pt1)
				pt1.x = dRect.midX + 4.0
				pth.addLine(to: pt1)
			} else {
				gap = min(60.0, gap)
				// left middle
				pt1 = .init(x: dRect.minX, y: dRect.midY)
				pth.move(to: pt1)
				pt1.x = dRect.midX - gap * 0.5
				pth.addLine(to: pt1)
				// right middle
				pt1.x = dRect.midX + gap * 0.5
				pth.move(to: pt1)
				pt1.x = dRect.maxX
				pth.addLine(to: pt1)
			}
//			if dRect.width >= arrowHeadWidth * 2.0 + 8.0 {
//				// left middle
//				pt1 = .init(x: dRect.minX, y: dRect.midY)
//				pth.move(to: pt1)
//				pt1.x = dRect.midX - 4.0
//				pth.addLine(to: pt1)
//				// right middle
//				pt1.x = dRect.midX + 4.0
//				pth.move(to: pt1)
//				pt1.x = dRect.maxX
//				pth.addLine(to: pt1)
//			} else if dRect.width >= arrowHeadWidth * 2.0 {
//				// center line
//				pt1 = .init(x: dRect.minX, y: dRect.midY)
//				pt1.x = dRect.midX - 4.0
//				pth.move(to: pt1)
//				pt1.x = dRect.midX + 4.0
//				pth.addLine(to: pt1)
//			}
			
			dRect = dRect.insetBy(dx: -2.0, dy: 0.0)
			
			// left and right edge lines
			pt1 = .init(x: dRect.minX + 0.5, y: dRect.minY)
			pth.move(to: pt1)
			pt1.y = dRect.maxY
			pth.addLine(to: pt1)
			
			pt1 = .init(x: dRect.maxX - 0.5, y: dRect.minY)
			pth.move(to: pt1)
			pt1.y = dRect.maxY
			pth.addLine(to: pt1)
			
		}
		
		shapeLayer.path = pth
		
	}
	
}
