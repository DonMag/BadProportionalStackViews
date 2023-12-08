//
//  ViewController.swift
//  BadProportionalStackViews
//
//  Created by Don Mag on 7/6/23.
//

import UIKit

class MyProportionalStackView: UIStackView {
	
	private var calcConstraints: [NSLayoutConstraint] = []
	private var useProportional: Bool = true
	
	override var distribution: UIStackView.Distribution {
		set {
			if newValue == .fillProportionally {
				self.useProportional = true
				super.distribution = .fill
			} else {
				self.useProportional = false
				super.distribution = newValue
			}
		}
		get {
			return self.useProportional ? .fillProportionally : super.distribution
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

		if !self.useProportional { return }
		
		if calcConstraints.isEmpty {
			var c: NSLayoutConstraint!
			for i in 0..<(arrangedSubviews.count - 1) {
				if axis == .vertical {
					c = arrangedSubviews[i].heightAnchor.constraint(equalToConstant: 100.0)
				} else {
					c = arrangedSubviews[i].widthAnchor.constraint(equalToConstant: 100.0)
				}
				c.priority = .required - 1
				c.isActive = true
				calcConstraints.append(c)
			}
		}
		
		// "spaces" are 1 less than number of arranged subviews
		let numSpaces: CGFloat = CGFloat(arrangedSubviews.count - 1)
		
		// we don't set the width constraint on the last arranged subview
		//	we let it "fill out the remaining space"
		//	otherwise, due to floating-point and rounding, we can get auto-layout complaints
		if axis == .vertical {
			let sumOfIntrinsicSizes = arrangedSubviews.reduce(0) { $0 + $1.intrinsicContentSize.height }
			let availableSize: CGFloat = bounds.height - (spacing * numSpaces)
			for i in 0..<(arrangedSubviews.count - 1) {
				calcConstraints[i].constant = arrangedSubviews[i].intrinsicContentSize.height / sumOfIntrinsicSizes * availableSize
			}
		} else {
			let sumOfIntrinsicSizes = arrangedSubviews.reduce(0) { $0 + $1.intrinsicContentSize.width }
			let availableSize: CGFloat = bounds.width - (spacing * numSpaces)
			for i in 0..<(arrangedSubviews.count - 1) {
				calcConstraints[i].constant = arrangedSubviews[i].intrinsicContentSize.width / sumOfIntrinsicSizes * availableSize
			}
		}
		
	}
	
}

class TestViewController: UIViewController {
	
	let sv = MyProportionalStackView()
	var stSpacing: CGFloat = 0.0
	
	let widths: [[CGFloat]] = [
		[1, 2, 3, 4],
		[1, 1, 1],
		[1, 1, 1, 1],
		[4, 2, 2],
		[100, 150, 200],
	]

	let colors: [UIColor] = [
		.systemRed, .systemGreen, .systemBlue, .systemYellow,
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		
		sv.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(sv)
		
		let curWidths = widths[3]
		
		for (i, w) in curWidths.enumerated() {
			let v = IntrinsicView()
			v.backgroundColor = colors[i % colors.count]
			v.myIntrinsicSize = .init(width: w, height: 40.0)
			sv.addArrangedSubview(v)
		}

		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			sv.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			sv.widthAnchor.constraint(equalToConstant: 600.0),
			sv.centerXAnchor.constraint(equalTo: g.centerXAnchor),
		])
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let t = touches.first else { return }
		let loc = t.location(in: self.view)
		if sv.frame.contains(loc) {
			sv.arrangedSubviews.forEach { v in
				print("iw:", v.intrinsicContentSize.width, "w:", v.frame.width)
			}
		} else {
			stSpacing += 15.0
			if stSpacing > 60.0 {
				stSpacing = 0.0
			}
			sv.spacing = stSpacing
		}
	}
	
}

class aDemoViewController: UIViewController {
	
	var curAxis: NSLayoutConstraint.Axis = .horizontal

	var stSpacing: CGFloat = 0.0
	
	var calcConstraints: [NSLayoutConstraint] = []

	var stackHolders: [UIView] = []
	var theSubViews: [[IntrinsicView]] = []
	var theMeasureViews: [[MeasureView]] = []

	let containerView: UIView = UIView()
	var containerW: NSLayoutConstraint!
	
	let colors: [UIColor] = [
		.systemRed, .systemGreen, .systemBlue,
	]
	
	var w: NSLayoutConstraint!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground

		for _ in 1...3 {
			let v = UIView()
			stackHolders.append(v)
			v.translatesAutoresizingMaskIntoConstraints = false
			containerView.addSubview(v)
		}

		let thePrompts: [String] = [
			"Caclulated:",
			"Set .spacing AFTER layout:",
			"Set .spacing BEFORE layout:",
		]

		stackHolders.forEach { hView in
			var vSubs: [IntrinsicView] = []
			var vMeas: [MeasureView] = []
			colors.forEach { c in
				let v = IntrinsicView()
				v.backgroundColor = c
				vSubs.append(v)
				let m = MeasureView()
				m.backgroundColor = c.withAlphaComponent(0.1)
				m.axis = curAxis
				m.translatesAutoresizingMaskIntoConstraints = false
				containerView.addSubview(m)
				vMeas.append(m)
				NSLayoutConstraint.activate([
					m.topAnchor.constraint(equalTo: hView.bottomAnchor, constant: 4.0),
					hView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
					hView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
				])
			}
			theSubViews.append(vSubs)
			theMeasureViews.append(vMeas)
		}
		
		var theLabels: [UILabel] = []
		thePrompts.forEach { str in
			let label = UILabel()
			label.font = .systemFont(ofSize: 15.0, weight: .regular)
			label.text = str
			label.translatesAutoresizingMaskIntoConstraints = false
			containerView.addSubview(label)
			NSLayoutConstraint.activate([
				label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0),
				label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0),
			])
			theLabels.append(label)
		}
		
		let btn = UIButton()
		btn.backgroundColor = .blue
		btn.setTitleColor(.white, for: .normal)
		btn.setTitleColor(.lightGray, for: .highlighted)
		btn.setTitle("Increase Spacing: 0.0", for: [])
		btn.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .regular)
		btn.layer.cornerRadius = 8.0
		btn.layer.borderWidth = 1
		btn.layer.borderColor = UIColor.blue.withAlphaComponent(0.5).cgColor
		
		btn.addTarget(self, action: #selector(changeSpacingTapped(_:)), for: .touchUpInside)
		
		btn.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(btn)

		containerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(containerView)
		
		containerW = containerView.widthAnchor.constraint(equalToConstant: 600.0)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			containerView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			containerView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			containerW,

			btn.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0),
			btn.widthAnchor.constraint(equalToConstant: 280.0),
			btn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

			theLabels[0].topAnchor.constraint(equalTo: btn.bottomAnchor, constant: 8.0),
			stackHolders[0].topAnchor.constraint(equalTo: theLabels[0].bottomAnchor, constant: 2.0),
			
			theLabels[1].topAnchor.constraint(equalTo: theMeasureViews[0][0].bottomAnchor, constant: 8.0),
			stackHolders[1].topAnchor.constraint(equalTo: theLabels[1].bottomAnchor, constant: 2.0),
			
			theLabels[2].topAnchor.constraint(equalTo: theMeasureViews[1][0].bottomAnchor, constant: 8.0),
			stackHolders[2].topAnchor.constraint(equalTo: theLabels[2].bottomAnchor, constant: 2.0),
			
			theMeasureViews[2][0].bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0),
			
		])
		
		let cStack = UIStackView()
		cStack.distribution = .fill
		cStack.translatesAutoresizingMaskIntoConstraints = false
		stackHolders[0].addSubview(cStack)
		NSLayoutConstraint.activate([
			cStack.topAnchor.constraint(equalTo: stackHolders[0].topAnchor),
			cStack.leadingAnchor.constraint(equalTo: stackHolders[0].leadingAnchor),
			cStack.trailingAnchor.constraint(equalTo: stackHolders[0].trailingAnchor),
			cStack.bottomAnchor.constraint(equalTo: stackHolders[0].bottomAnchor),
		])
		for (v, mv) in zip(theSubViews[0], theMeasureViews[0]) {
			cStack.addArrangedSubview(v)
			NSLayoutConstraint.activate([
				mv.leadingAnchor.constraint(equalTo: v.leadingAnchor),
				mv.trailingAnchor.constraint(equalTo: v.trailingAnchor),
			])
			let c = v.widthAnchor.constraint(equalToConstant: 100.0)
			c.priority = .required - 1
			c.isActive = true
			calcConstraints.append(c)
		}
		
		containerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

		let widths: [[CGFloat]] = [
			[1, 2, 3],
			[1, 1, 1],
			[100, 150, 200],
		]
		let curWidths = widths[0]
		theSubViews.forEach { vSubs in
			for (v, w) in zip(vSubs, curWidths) {
				v.myIntrinsicSize = .init(width: w, height: 30.0)
			}
		}
		
		rebuildStacks()
		updateCalcStack()
	}
	
	func rebuildStacks() {
		if let v = stackHolders[1].subviews.first as? UIStackView {
			v.removeFromSuperview()
		}
		do {
			let sh = stackHolders[1]
			let s = UIStackView()
			s.translatesAutoresizingMaskIntoConstraints = false
			sh.addSubview(s)
			s.distribution = .fillProportionally
			NSLayoutConstraint.activate([
				s.topAnchor.constraint(equalTo: sh.topAnchor),
				s.leadingAnchor.constraint(equalTo: sh.leadingAnchor),
				s.trailingAnchor.constraint(equalTo: sh.trailingAnchor),
				s.bottomAnchor.constraint(equalTo: sh.bottomAnchor),
			])
			for (v, mv) in zip(theSubViews[1], theMeasureViews[1]) {
				s.addArrangedSubview(v)
				NSLayoutConstraint.activate([
					mv.leadingAnchor.constraint(equalTo: v.leadingAnchor),
					mv.trailingAnchor.constraint(equalTo: v.trailingAnchor),
				])
			}
			s.setNeedsLayout()
			s.layoutIfNeeded()
			s.spacing = stSpacing
		}
		if let v = stackHolders[2].subviews.first as? UIStackView {
			v.removeFromSuperview()
		}
		do {
			let sh = stackHolders[2]
			let s = UIStackView()
			s.translatesAutoresizingMaskIntoConstraints = false
			sh.addSubview(s)
			s.distribution = .fillProportionally
			NSLayoutConstraint.activate([
				s.topAnchor.constraint(equalTo: sh.topAnchor),
				s.leadingAnchor.constraint(equalTo: sh.leadingAnchor),
				s.trailingAnchor.constraint(equalTo: sh.trailingAnchor),
				s.bottomAnchor.constraint(equalTo: sh.bottomAnchor),
			])
			for (v, mv) in zip(theSubViews[2], theMeasureViews[2]) {
				s.addArrangedSubview(v)
				NSLayoutConstraint.activate([
					mv.leadingAnchor.constraint(equalTo: v.leadingAnchor),
					mv.trailingAnchor.constraint(equalTo: v.trailingAnchor),
				])
			}
			s.spacing = stSpacing
			s.setNeedsLayout()
			s.layoutIfNeeded()
		}
		updateCalcStack()
	}
	
	var cSize: CGSize = .init(width: -1.0, height: -1.0)
	var vw: CGFloat = 0.0
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if nil == containerView.superview { return }
		if vw != view.frame.width {
			vw = view.frame.width
			containerW.constant = view.frame.width < 500.0 ? 300.0 : 600.0
			containerView.setNeedsLayout()
			containerView.layoutIfNeeded()
			updateCalcStack()
		}
	}
	
//	@objc func segChanged(_ sender: UISegmentedControl) {
//		let widths: [[CGFloat]] = [
//			[1, 2, 3],
//			[1, 1, 1],
//			[100, 150, 200],
//		]
//		let curWidths = widths[sender.selectedSegmentIndex]
//		theStacks.forEach { sv in
//			let curSP = sv.spacing
//			sv.spacing = 0
//			for (v, w) in zip(sv.arrangedSubviews, curWidths) {
//				if let v = v as? IntrinsicView {
//					v.myIntrinsicSize = .init(width: w, height: 30.0)
//				}
//			}
//			sv.spacing = curSP
//		}
//		updateViews()
//	}
	
	func updateCalcStack() {
		guard let cStack = stackHolders[0].subviews.first as? UIStackView else { return }
		cStack.spacing = stSpacing
		let sumOfIntrinsicSizes = cStack.arrangedSubviews.reduce(0) { $0 + $1.intrinsicContentSize.width }
		let availableSize: CGFloat = cStack.frame.width - (cStack.spacing * 2.0)
		for i in 0..<(cStack.arrangedSubviews.count - 1) {
			calcConstraints[i].constant = cStack.arrangedSubviews[i].intrinsicContentSize.width / sumOfIntrinsicSizes * availableSize
			calcConstraints[i].priority = calcConstraints[i].constant > 0 ? .required : .defaultHigh
		}
		theMeasureViews[0].forEach { mv in
			mv.setNeedsLayout()
		}
	}
	
	@objc func changeSpacingTapped(_ sender: Any?) {
		if nil == containerView.superview {
			w.constant += 10.0
			if w.constant > 300.0 {
				w.constant = 20.0
			}
			return
		}
		let spMax: CGFloat = containerW.constant > 300.0 ? 120.0 : 60.0
		stSpacing += 15.0
		if stSpacing > spMax {
			stSpacing = 0.0
		}
		if let b = sender as? UIButton {
			b.setTitle("Increase Spacing: \(stSpacing)", for: [])
		}
		rebuildStacks()
	}
		
}

class DemoViewController: UIViewController {
	
	var curAxis: NSLayoutConstraint.Axis = .horizontal
	
	var stSpacing: CGFloat = 0.0
	
	var calcConstraints: [NSLayoutConstraint] = []
	
	var stackHolders: [UIView] = []
	var theSubViews: [[IntrinsicView]] = []
	var theMeasureViews: [[MeasureView]] = []
	
	let containerView: UIView = UIView()
	var containerW: NSLayoutConstraint!
	
	let colors: [UIColor] = [
		.systemRed, .systemGreen, .systemBlue,
	]
	
	var w: NSLayoutConstraint!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		for _ in 1...3 {
			let v = UIView()
			stackHolders.append(v)
			v.translatesAutoresizingMaskIntoConstraints = false
			containerView.addSubview(v)
		}
		
		let thePrompts: [String] = [
			"Caclulated:",
			"Set .spacing AFTER layout:",
			"Set .spacing BEFORE layout:",
		]
		
		stackHolders.forEach { hView in
			var vSubs: [IntrinsicView] = []
			var vMeas: [MeasureView] = []
			colors.forEach { c in
				let v = IntrinsicView()
				v.backgroundColor = c
				vSubs.append(v)
				let m = MeasureView()
				m.backgroundColor = c.withAlphaComponent(0.1)
				m.axis = curAxis
				m.translatesAutoresizingMaskIntoConstraints = false
				containerView.addSubview(m)
				vMeas.append(m)
				NSLayoutConstraint.activate([
					m.topAnchor.constraint(equalTo: hView.bottomAnchor, constant: 4.0),
					hView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
					hView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
				])
			}
			theSubViews.append(vSubs)
			theMeasureViews.append(vMeas)
		}
		
		var theLabels: [UILabel] = []
		thePrompts.forEach { str in
			let label = UILabel()
			label.font = .systemFont(ofSize: 15.0, weight: .regular)
			label.text = str
			label.translatesAutoresizingMaskIntoConstraints = false
			containerView.addSubview(label)
			NSLayoutConstraint.activate([
				label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0),
				label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0),
			])
			theLabels.append(label)
		}
		
		let btn = UIButton()
		btn.backgroundColor = .blue
		btn.setTitleColor(.white, for: .normal)
		btn.setTitleColor(.lightGray, for: .highlighted)
		btn.setTitle("Increase Spacing: 0.0", for: [])
		btn.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .regular)
		btn.layer.cornerRadius = 8.0
		btn.layer.borderWidth = 1
		btn.layer.borderColor = UIColor.blue.withAlphaComponent(0.5).cgColor
		
		btn.addTarget(self, action: #selector(changeSpacingTapped(_:)), for: .touchUpInside)
		
		btn.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(btn)
		
		containerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(containerView)
		
		containerW = containerView.widthAnchor.constraint(equalToConstant: 600.0)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			containerView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			containerView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			containerW,
			
			btn.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0),
			btn.widthAnchor.constraint(equalToConstant: 280.0),
			btn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
			
			theLabels[0].topAnchor.constraint(equalTo: btn.bottomAnchor, constant: 8.0),
			stackHolders[0].topAnchor.constraint(equalTo: theLabels[0].bottomAnchor, constant: 2.0),
			
			theLabels[1].topAnchor.constraint(equalTo: theMeasureViews[0][0].bottomAnchor, constant: 8.0),
			stackHolders[1].topAnchor.constraint(equalTo: theLabels[1].bottomAnchor, constant: 2.0),
			
			theLabels[2].topAnchor.constraint(equalTo: theMeasureViews[1][0].bottomAnchor, constant: 8.0),
			stackHolders[2].topAnchor.constraint(equalTo: theLabels[2].bottomAnchor, constant: 2.0),
			
			theMeasureViews[2][0].bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0),
			
		])
		
		let cStack = MyProportionalStackView()
		cStack.translatesAutoresizingMaskIntoConstraints = false
		stackHolders[0].addSubview(cStack)
		NSLayoutConstraint.activate([
			cStack.topAnchor.constraint(equalTo: stackHolders[0].topAnchor),
			cStack.leadingAnchor.constraint(equalTo: stackHolders[0].leadingAnchor),
			cStack.trailingAnchor.constraint(equalTo: stackHolders[0].trailingAnchor),
			cStack.bottomAnchor.constraint(equalTo: stackHolders[0].bottomAnchor),
		])
		for (v, mv) in zip(theSubViews[0], theMeasureViews[0]) {
			cStack.addArrangedSubview(v)
			NSLayoutConstraint.activate([
				mv.leadingAnchor.constraint(equalTo: v.leadingAnchor),
				mv.trailingAnchor.constraint(equalTo: v.trailingAnchor),
			])
		}
		
		containerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		
		let widths: [[CGFloat]] = [
			[1, 2, 3],
			[1, 1, 1],
			[100, 150, 200],
		]
		let curWidths = widths[0]
		theSubViews.forEach { vSubs in
			for (v, w) in zip(vSubs, curWidths) {
				v.myIntrinsicSize = .init(width: w, height: 30.0)
			}
		}
		
		rebuildStacks()
	}
	
	func rebuildStacks() {
		// we don't need to rebuild the first stack view
		//	it's an instance of MyProportionalStackView
		if let v = stackHolders[0].subviews.first as? MyProportionalStackView {
			v.spacing = stSpacing
		}
		
		// remove and rebuild the two UIStackView instances
		if let v = stackHolders[1].subviews.first as? UIStackView {
			v.removeFromSuperview()
		}
		do {
			let sh = stackHolders[1]
			let s = UIStackView()
			s.translatesAutoresizingMaskIntoConstraints = false
			sh.addSubview(s)
			s.distribution = .fillProportionally
			NSLayoutConstraint.activate([
				s.topAnchor.constraint(equalTo: sh.topAnchor),
				s.leadingAnchor.constraint(equalTo: sh.leadingAnchor),
				s.trailingAnchor.constraint(equalTo: sh.trailingAnchor),
				s.bottomAnchor.constraint(equalTo: sh.bottomAnchor),
			])
			for (v, mv) in zip(theSubViews[1], theMeasureViews[1]) {
				s.addArrangedSubview(v)
				NSLayoutConstraint.activate([
					mv.leadingAnchor.constraint(equalTo: v.leadingAnchor),
					mv.trailingAnchor.constraint(equalTo: v.trailingAnchor),
				])
			}
			s.setNeedsLayout()
			s.layoutIfNeeded()
			s.spacing = stSpacing
		}
		if let v = stackHolders[2].subviews.first as? UIStackView {
			v.removeFromSuperview()
		}
		do {
			let sh = stackHolders[2]
			let s = UIStackView()
			s.translatesAutoresizingMaskIntoConstraints = false
			sh.addSubview(s)
			s.distribution = .fillProportionally
			NSLayoutConstraint.activate([
				s.topAnchor.constraint(equalTo: sh.topAnchor),
				s.leadingAnchor.constraint(equalTo: sh.leadingAnchor),
				s.trailingAnchor.constraint(equalTo: sh.trailingAnchor),
				s.bottomAnchor.constraint(equalTo: sh.bottomAnchor),
			])
			for (v, mv) in zip(theSubViews[2], theMeasureViews[2]) {
				s.addArrangedSubview(v)
				NSLayoutConstraint.activate([
					mv.leadingAnchor.constraint(equalTo: v.leadingAnchor),
					mv.trailingAnchor.constraint(equalTo: v.trailingAnchor),
				])
			}
			s.spacing = stSpacing
			s.setNeedsLayout()
			s.layoutIfNeeded()
		}
	}
	
	var cSize: CGSize = .init(width: -1.0, height: -1.0)
	var vw: CGFloat = 0.0
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if nil == containerView.superview { return }
		if vw != view.frame.width {
			vw = view.frame.width
			containerW.constant = view.frame.width < 500.0 ? 300.0 : 600.0
			containerView.setNeedsLayout()
			containerView.layoutIfNeeded()
		}
	}
	
	//	@objc func segChanged(_ sender: UISegmentedControl) {
	//		let widths: [[CGFloat]] = [
	//			[1, 2, 3],
	//			[1, 1, 1],
	//			[100, 150, 200],
	//		]
	//		let curWidths = widths[sender.selectedSegmentIndex]
	//		theStacks.forEach { sv in
	//			let curSP = sv.spacing
	//			sv.spacing = 0
	//			for (v, w) in zip(sv.arrangedSubviews, curWidths) {
	//				if let v = v as? IntrinsicView {
	//					v.myIntrinsicSize = .init(width: w, height: 30.0)
	//				}
	//			}
	//			sv.spacing = curSP
	//		}
	//		updateViews()
	//	}
	
	@objc func changeSpacingTapped(_ sender: Any?) {
		if nil == containerView.superview {
			w.constant += 10.0
			if w.constant > 300.0 {
				w.constant = 20.0
			}
			return
		}
		let spMax: CGFloat = containerW.constant > 300.0 ? 120.0 : 60.0
		stSpacing += 15.0
		if stSpacing > spMax {
			stSpacing = 0.0
		}
		if let b = sender as? UIButton {
			b.setTitle("Increase Spacing: \(stSpacing)", for: [])
		}
		rebuildStacks()
	}
	
}

