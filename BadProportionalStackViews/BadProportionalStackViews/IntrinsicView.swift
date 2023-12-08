//
//  IntrinsicView.swift
//  BadProportionalStackViews
//
//  Created by Don Mag on 7/6/23.
//

import UIKit

class IntrinsicView: UIView {

	public var showWidth: Bool = true
	public var showHeight: Bool = false
	
	public var myIntrinsicSize: CGSize = .zero {
		didSet {
			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}
	
	private let mLabel: UILabel = {
		let v = UILabel()
		v.font = .monospacedDigitSystemFont(ofSize: 12.0, weight: .bold)
		v.textAlignment = .center
		v.textColor = .black
		return v
	}()
	
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
	private func commonInit() {
		mLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(mLabel)
		NSLayoutConstraint.activate([
			mLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
			mLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
		])
	}
	override func layoutSubviews() {
		var s: String = ""
		if showWidth {
			s = "\(self.intrinsicContentSize.width)"
			if showHeight {
				s = "\(self.intrinsicContentSize)"
			}
		} else if showHeight {
			s = "\(self.intrinsicContentSize.height)"
		}
		mLabel.text = s
	}
	
}
