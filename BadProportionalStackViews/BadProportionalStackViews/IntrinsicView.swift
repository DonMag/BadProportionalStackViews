//
//  IntrinsicView.swift
//  BadProportionalStackViews
//
//  Created by Don Mag on 7/6/23.
//

import UIKit

class IntrinsicView: UIView {

	let mLabel: UILabel = {
		let v = UILabel()
		v.font = .monospacedDigitSystemFont(ofSize: 12.0, weight: .bold)
		v.textAlignment = .center
		v.textColor = .black
		return v
	}()

	public var myIntrinsicSize: CGSize = .zero {
		didSet {
			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}
	
	override var intrinsicContentSize: CGSize {
		return myIntrinsicSize
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
		mLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(mLabel)
		NSLayoutConstraint.activate([
			mLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
			mLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
		])
	}
	override func layoutSubviews() {
		mLabel.text = "\(self.intrinsicContentSize.width)"
		return()
		if self.intrinsicContentSize.width != self.intrinsicContentSize.height {
			mLabel.text = "\(self.intrinsicContentSize)"
		} else {
			mLabel.text = "\(self.intrinsicContentSize.width)"
		}
	}
	
}
