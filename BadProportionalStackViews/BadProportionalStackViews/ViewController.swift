//
//  ViewController.swift
//  BadProportionalStackViews
//
//  Created by Don Mag on 7/6/23.
//

import UIKit

class MyProportionalStackView: UIStackView {
	var calcConstraints: [NSLayoutConstraint] = []
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		print(#function)
		
		distribution = .fill
		
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
		
		if axis == .vertical {
			let sumOfIntrinsicSizes = arrangedSubviews.reduce(0) { $0 + $1.intrinsicContentSize.height }
			let availableSize: CGFloat = bounds.height - (spacing * 2.0)
			for i in 0..<(arrangedSubviews.count - 1) {
				calcConstraints[i].constant = arrangedSubviews[i].intrinsicContentSize.height / sumOfIntrinsicSizes * availableSize
			}
		} else {
			let sumOfIntrinsicSizes = arrangedSubviews.reduce(0) { $0 + $1.intrinsicContentSize.width }
			let availableSize: CGFloat = bounds.width - (spacing * 2.0)
			for i in 0..<(arrangedSubviews.count - 1) {
				calcConstraints[i].constant = arrangedSubviews[i].intrinsicContentSize.width / sumOfIntrinsicSizes * availableSize
			}
		}
		
	}
	
}

class custViewController: UIViewController {
	
	let stackView = MyProportionalStackView()

	var stSpacing: CGFloat = 0.0
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		stSpacing += 15.0
		if stSpacing > 120.0 {
			stSpacing = 0.0
		}
		stackView.spacing = stSpacing
		DispatchQueue.main.async {
			self.stackView.arrangedSubviews.forEach { v in
				print(v.intrinsicContentSize, v.frame.size)
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide
		
		stackView.axis = .horizontal
		stackView.spacing = 0
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			stackView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			stackView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			stackView.widthAnchor.constraint(equalToConstant: 600.0),
			stackView.heightAnchor.constraint(equalToConstant: 100.0),
		])

		let colors: [UIColor] = [
			.systemRed, .systemGreen, .systemBlue, //.systemYellow
		]

		var vals: [CGFloat] = []
		for i in 1...colors.count {
			vals.append(CGFloat(i))
		}
		[stackView].forEach { sv in
			for (val, c) in zip(vals, colors) {
				let v = IntrinsicView()
				v.myIntrinsicSize = .init(width: val, height: val)
				v.backgroundColor = c
				stackView.addArrangedSubview(v)
			}
		}

	}
}


class tViewController: UIViewController {
	let v = IntrinsicView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		v.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(v)
		let g = view.safeAreaLayoutGuide
		
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 40
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			stackView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			stackView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
		])

		
		NSLayoutConstraint.activate([
			v.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			//v.widthAnchor.constraint(equalToConstant: 100.0),
			v.heightAnchor.constraint(equalToConstant: 100.0),
			v.centerXAnchor.constraint(equalTo: g.centerXAnchor),
		])
		v.myIntrinsicSize = .init(width: 240.0, height: 0.0)
		
		let mv = MeasureView()
		mv.axis = .vertical
		mv.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(mv)
		NSLayoutConstraint.activate([
			mv.topAnchor.constraint(equalTo: v.bottomAnchor, constant: 4.0),
			mv.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 0.0),
			mv.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: 0.0),
			mv.heightAnchor.constraint(equalToConstant: 180.0),
		])
		
		v.backgroundColor = .blue
	}
}

struct MyOptions {
	var axis: NSLayoutConstraint.Axis = .vertical
	var useLabels: Bool = false
	var title: String = ""
}

class MenuViewController: UIViewController {
	
	let options: [MyOptions] = [
		MyOptions(axis: .vertical, useLabels: false, title: "Vertical Views"),
		MyOptions(axis: .horizontal, useLabels: false, title: "Horizontal Views"),
		MyOptions(axis: .vertical, useLabels: true, title: "Vertical Labels"),
		MyOptions(axis: .horizontal, useLabels: true, title: "Horizontal Labels"),
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		let g = view.safeAreaLayoutGuide

		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 24
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			stackView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			stackView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
		])
		
		options.forEach { opts in
			let b = UIButton()
			b.backgroundColor = .systemBlue
			b.setTitleColor(.white, for: .normal)
			b.setTitleColor(.lightGray, for: .highlighted)
			b.setTitle(opts.title, for: [])
			b.layer.cornerRadius = 8
			b.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
			b.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
			b.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
			stackView.addArrangedSubview(b)
		}
		
	}
	
	@objc func btnTapped(_ sender: UIButton) {
		if let sv = sender.superview as? UIStackView,
		   let idx = sv.arrangedSubviews.firstIndex(of: sender) {

			let vc: DemoViewController = DemoViewController()
			vc.curAxis = options[idx].axis
			vc.useLabels = options[idx].useLabels
			vc.title = options[idx].title
			
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	@IBAction func gotTap(_ sender: UIButton) {
		if let sv = sender.superview as? UIStackView,
		   let idx = sv.arrangedSubviews.firstIndex(of: sender) {
			
			let vc: DemoViewController = DemoViewController()
			
			switch idx {
			case 0:
				vc.curAxis = .vertical
				vc.useLabels = true
			case 1:
				vc.curAxis = .horizontal
				vc.useLabels = true
			case 2:
				vc.curAxis = .vertical
				vc.useLabels = false
			case 3:
				vc.curAxis = .horizontal
				vc.useLabels = false
			default:
				()
			}
			
			self.navigationController?.pushViewController(vc, animated: true)

		}
	}
	
}

class origDemoViewController: UIViewController {
	
	var curAxis: NSLayoutConstraint.Axis = .vertical
	var useLabels: Bool = false
	
	let aStack = UIStackView()
	let bStack = UIStackView()
	
	var stSpacing: CGFloat = 0.0
	
	var aViews: [UIView] = []
	var bViews: [UIView] = []
	var aMeasureViews: [MeasureView] = []
	var bMeasureViews: [MeasureView] = []
	var measureViews: [MeasureView] = []
	var calcConstraints: [NSLayoutConstraint] = []
	
	let containerView: UIView = UIView()
	
	let colors: [UIColor] = [
		.systemRed, .systemGreen, .systemBlue, //.systemYellow
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		view.clipsToBounds = true
		
		for _ in 0..<colors.count {
			let mvA = MeasureView()
			mvA.translatesAutoresizingMaskIntoConstraints = false
			aMeasureViews.append(mvA)
			containerView.addSubview(mvA)
			let mvB = MeasureView()
			mvB.translatesAutoresizingMaskIntoConstraints = false
			bMeasureViews.append(mvB)
			containerView.addSubview(mvB)
		}

		[aStack, bStack].forEach { sv in
			sv.translatesAutoresizingMaskIntoConstraints = false
			containerView.addSubview(sv)
		}

		containerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(containerView)

		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			containerView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			containerView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
		])
		
		aStack.distribution = .fill
		bStack.distribution = .fillProportionally
		
		if useLabels {
			addLabels()
		} else {
			addIntrinsicViews()
		}
		constrainViews()
		
		containerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
	}
	
	var cSize: CGSize = .init(width: -1.0, height: -1.0)
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if cSize != containerView.frame.size {
			containerView.setNeedsLayout()
			containerView.layoutIfNeeded()
			cSize = containerView.frame.size
			updateViews()
		}
	}
	
	func updateViews() {
		
		if curAxis == .vertical {
			let sumOfIntrinsicSizes = aViews.reduce(0) { $0 + $1.intrinsicContentSize.height }
			let availableSize: CGFloat = aStack.frame.height - (aStack.spacing * 2.0)
			for i in 0..<(aViews.count - 1) {
				calcConstraints[i].constant = aViews[i].intrinsicContentSize.height / sumOfIntrinsicSizes * availableSize
			}
		} else {
			let sumOfIntrinsicSizes = aViews.reduce(0) { $0 + $1.intrinsicContentSize.width }
			let availableSize: CGFloat = aStack.frame.width - (aStack.spacing * 2.0)
			for i in 0..<(aViews.count - 1) {
				calcConstraints[i].constant = aViews[i].intrinsicContentSize.width / sumOfIntrinsicSizes * availableSize
			}
		}

		//reAddBViews()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		stSpacing += 15.0
		if stSpacing > 120.0 {
			stSpacing = 0.0
		}
		aStack.spacing = stSpacing
		bStack.spacing = stSpacing
		updateViews()
	}
	
	func addIntrinsicViews() {
		var vals: [CGFloat] = []
		for i in 1...colors.count {
			vals.append(CGFloat(i))
		}
		[aStack, bStack].forEach { sv in
			sv.axis = curAxis
			for (val, c) in zip(vals, colors) {
				let v = IntrinsicView()
				v.myIntrinsicSize = .init(width: val, height: val)
				v.backgroundColor = c
				if sv == aStack {
					aViews.append(v)
				} else {
					bViews.append(v)
				}
				sv.addArrangedSubview(v)
			}
		}
	}
	func addLabels() {
	
		let font: UIFont = .monospacedSystemFont(ofSize: curAxis == .horizontal ? 16.0 : 15.0, weight: .regular)
		
		var strs: [String] = []
		if curAxis == .vertical {
			var s: String = "1"
			strs.append(s)
			for i in 2...colors.count {
				s += "\n\(i)"
				strs.append(s)
			}
		} else {
			var s: String = ""
			for i in 1...colors.count {
				s += "\(i)"
				strs.append(s)
			}
		}
		[aStack, bStack].forEach { sv in
			sv.axis = curAxis
			for (s, c) in zip(strs, colors) {
				let l = UILabel()
				l.font = font
				l.textAlignment = .center
				l.numberOfLines = curAxis == .vertical ? 0 : 1
				l.text = s
				l.backgroundColor = c
				l.textColor = .white
				if sv == aStack {
					aViews.append(l)
				} else {
					bViews.append(l)
				}
				sv.addArrangedSubview(l)
			}
		}
	}
	func constrainViews() {
		
		if curAxis == .vertical {
			for i in 0..<aViews.count {
				aMeasureViews[i].topAnchor.constraint(equalTo: aViews[i].topAnchor).isActive = true
				aMeasureViews[i].bottomAnchor.constraint(equalTo: aViews[i].bottomAnchor).isActive = true
				bMeasureViews[i].topAnchor.constraint(equalTo: bViews[i].topAnchor).isActive = true
				bMeasureViews[i].bottomAnchor.constraint(equalTo: bViews[i].bottomAnchor).isActive = true
				
				aMeasureViews[i].leadingAnchor.constraint(equalTo: aStack.trailingAnchor, constant: 8.0).isActive = true
				bMeasureViews[i].leadingAnchor.constraint(equalTo: aMeasureViews[i].trailingAnchor, constant: 24.0).isActive = true
				bMeasureViews[i].trailingAnchor.constraint(equalTo: bStack.leadingAnchor, constant: -8.0).isActive = true
				
				aMeasureViews[i].axis = .vertical
				bMeasureViews[i].axis = .vertical
			}
			for i in 0..<(aViews.count - 1) {
				let c = aViews[i].heightAnchor.constraint(equalToConstant: 100.0)
				c.priority = .required - 1
				c.isActive = true
				calcConstraints.append(c)
			}
			
			let v = containerView
			NSLayoutConstraint.activate([
				aStack.topAnchor.constraint(equalTo: v.topAnchor, constant: 0.0),
				aStack.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 0.0),
				aStack.heightAnchor.constraint(equalToConstant: 600.0),
				aStack.widthAnchor.constraint(equalToConstant: 80.0),
				
				bStack.topAnchor.constraint(equalTo: aStack.topAnchor),
				bStack.heightAnchor.constraint(equalTo: aStack.heightAnchor),
				bStack.widthAnchor.constraint(equalTo: aStack.widthAnchor),
				
				aStack.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: 0.0),
				bStack.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: 0.0),
			])
		} else {
			for i in 0..<aViews.count {
				aMeasureViews[i].leadingAnchor.constraint(equalTo: aViews[i].leadingAnchor).isActive = true
				aMeasureViews[i].trailingAnchor.constraint(equalTo: aViews[i].trailingAnchor).isActive = true
				bMeasureViews[i].leadingAnchor.constraint(equalTo: bViews[i].leadingAnchor).isActive = true
				bMeasureViews[i].trailingAnchor.constraint(equalTo: bViews[i].trailingAnchor).isActive = true
				
				aMeasureViews[i].topAnchor.constraint(equalTo: aStack.bottomAnchor, constant: 8.0).isActive = true
				bMeasureViews[i].topAnchor.constraint(equalTo: aMeasureViews[i].bottomAnchor, constant: 24.0).isActive = true
				bMeasureViews[i].bottomAnchor.constraint(equalTo: bStack.topAnchor, constant: -8.0).isActive = true
				
				aMeasureViews[i].axis = .horizontal
				bMeasureViews[i].axis = .horizontal
				aMeasureViews[i].heightAnchor.constraint(equalToConstant: 50.0).isActive = true
				bMeasureViews[i].heightAnchor.constraint(equalTo: aMeasureViews[i].heightAnchor).isActive = true
			}
			for i in 0..<(aViews.count - 1) {
				let c = aViews[i].widthAnchor.constraint(equalToConstant: 100.0)
				c.priority = .required - 1
				c.isActive = true
				calcConstraints.append(c)
			}
			
			let v = containerView
			NSLayoutConstraint.activate([
				aStack.topAnchor.constraint(equalTo: v.topAnchor, constant: 0.0),
				aStack.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 0.0),
				aStack.heightAnchor.constraint(equalToConstant: 60.0),
				aStack.widthAnchor.constraint(equalToConstant: 600.0),
				
				bStack.leadingAnchor.constraint(equalTo: aStack.leadingAnchor),
				bStack.heightAnchor.constraint(equalTo: aStack.heightAnchor),
				bStack.widthAnchor.constraint(equalTo: aStack.widthAnchor),
				
				aStack.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: 0.0),
				bStack.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: 0.0),
			])
		}

	}
	func reAddBViews() {
		bViews.forEach { v in
			v.removeFromSuperview()
			bStack.addArrangedSubview(v)
		}
		for (mv, bv) in zip(bMeasureViews, bViews) {
			NSLayoutConstraint.activate([
				mv.leadingAnchor.constraint(equalTo: bv.leadingAnchor),
				mv.trailingAnchor.constraint(equalTo: bv.trailingAnchor),
			])
		}
	}
}

class MyCView: UIView {}
class MySCView: UIView {}

class DemoViewController: UIViewController {
	
	var curAxis: NSLayoutConstraint.Axis = .horizontal
	var useLabels: Bool = false
	
	var calcStack = UIStackView()
	var beforeStack = UIStackView()
	var afterStack = UIStackView()

	var stSpacing: CGFloat = 0.0
	
	var calcConstraints: [NSLayoutConstraint] = []

	var stackHolders: [UIView] = []
	var theStacks: [UIStackView] = []
	var theSubViews: [[IntrinsicView]] = []
	var theMeasureViews: [[MeasureView]] = []

	let containerView: MyCView = MyCView()
	
	let colors: [UIColor] = [
		.systemRed, .systemGreen, .systemBlue,
	]
	
	var w: NSLayoutConstraint!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		let m1 = MeasureView()
		m1.axis = .horizontal
		m1.translatesAutoresizingMaskIntoConstraints = false
		m1.backgroundColor = .systemBlue.withAlphaComponent(0.25)
		view.addSubview(m1)
		w = m1.widthAnchor.constraint(equalToConstant: 20.0)
		NSLayoutConstraint.activate([
			m1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
			m1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
			w,
			//m1.widthAnchor.constraint(equalToConstant: 212.0),
		])
		
		m1.isHidden = true

		theStacks = [calcStack, beforeStack, afterStack]

		for _ in 0..<3 {
			let v = MySCView()
			stackHolders.append(v)
			v.translatesAutoresizingMaskIntoConstraints = false
			containerView.addSubview(v)
		}
		
		let thePrompts: [String] = [
			"Caclulated Proportional Distribution - this is what I'd expect:",
			"Set .spacing AFTER adding arranged subviews:",
			"Set .spacing BEFORE adding arranged subviews:",
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
					m.topAnchor.constraint(equalTo: hView.bottomAnchor, constant: 8.0),
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
		
		containerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(containerView)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			containerView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			containerView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			containerView.widthAnchor.constraint(equalToConstant: 600.0),
			
			theLabels[0].topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0),
			stackHolders[0].topAnchor.constraint(equalTo: theLabels[0].bottomAnchor, constant: 4.0),
			
			theLabels[1].topAnchor.constraint(equalTo: theMeasureViews[0][0].bottomAnchor, constant: 12.0),
			stackHolders[1].topAnchor.constraint(equalTo: theLabels[1].bottomAnchor, constant: 4.0),
			
			theLabels[2].topAnchor.constraint(equalTo: theMeasureViews[1][0].bottomAnchor, constant: 12.0),
			stackHolders[2].topAnchor.constraint(equalTo: theLabels[2].bottomAnchor, constant: 4.0),
			
			theMeasureViews[2][0].bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0),
			
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
				mv.topAnchor.constraint(equalTo: cStack.bottomAnchor, constant: 4.0),
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
				if let v = v as? IntrinsicView {
					v.myIntrinsicSize = .init(width: w, height: 30.0)
				}
			}
		}
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
		rebuildStacks()
		//updateViews()
	}
	
	func rebuildStacks() {
		if let v = stackHolders[1].subviews.first as? UIStackView {
			v.removeFromSuperview()
		}
		do {
			let s = UIStackView()
			s.translatesAutoresizingMaskIntoConstraints = false
			stackHolders[1].addSubview(s)
			s.distribution = .fillProportionally
			s.spacing = stSpacing
			NSLayoutConstraint.activate([
				s.topAnchor.constraint(equalTo: stackHolders[1].topAnchor),
				s.leadingAnchor.constraint(equalTo: stackHolders[1].leadingAnchor),
				s.trailingAnchor.constraint(equalTo: stackHolders[1].trailingAnchor),
				s.bottomAnchor.constraint(equalTo: stackHolders[1].bottomAnchor),
			])
			for (v, mv) in zip(theSubViews[1], theMeasureViews[1]) {
				s.addArrangedSubview(v)
				NSLayoutConstraint.activate([
					mv.leadingAnchor.constraint(equalTo: v.leadingAnchor),
					mv.trailingAnchor.constraint(equalTo: v.trailingAnchor),
					mv.topAnchor.constraint(equalTo: s.bottomAnchor, constant: 4.0),
				])
			}
		}
		if let v = stackHolders[2].subviews.first as? UIStackView {
			v.removeFromSuperview()
		}
		do {
			let s = UIStackView()
			s.translatesAutoresizingMaskIntoConstraints = false
			stackHolders[2].addSubview(s)
			s.distribution = .fillProportionally
			NSLayoutConstraint.activate([
				s.topAnchor.constraint(equalTo: stackHolders[2].topAnchor),
				s.leadingAnchor.constraint(equalTo: stackHolders[2].leadingAnchor),
				s.trailingAnchor.constraint(equalTo: stackHolders[2].trailingAnchor),
				s.bottomAnchor.constraint(equalTo: stackHolders[2].bottomAnchor),
			])
			for (v, mv) in zip(theSubViews[2], theMeasureViews[2]) {
				s.addArrangedSubview(v)
				NSLayoutConstraint.activate([
					mv.leadingAnchor.constraint(equalTo: v.leadingAnchor),
					mv.trailingAnchor.constraint(equalTo: v.trailingAnchor),
					mv.topAnchor.constraint(equalTo: s.bottomAnchor, constant: 4.0),
				])
			}
			s.spacing = stSpacing
		}
	}
	
	var cSize: CGSize = .init(width: -1.0, height: -1.0)
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if nil == containerView.superview { return }
		if cSize != containerView.frame.size {
			containerView.setNeedsLayout()
			containerView.layoutIfNeeded()
			cSize = containerView.frame.size
			//updateViews()
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
	
	func updateViews() {
		guard let cStack = stackHolders[0].subviews.first as? UIStackView else { return }
		let sumOfIntrinsicSizes = cStack.arrangedSubviews.reduce(0) { $0 + $1.intrinsicContentSize.width }
		let availableSize: CGFloat = cStack.frame.width - (cStack.spacing * 2.0)
		for i in 0..<(cStack.arrangedSubviews.count - 1) {
			calcConstraints[i].constant = cStack.arrangedSubviews[i].intrinsicContentSize.width / sumOfIntrinsicSizes * availableSize
		}
		//reAddAfterViews()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if nil == containerView.superview {
			w.constant += 10.0
			if w.constant > 300.0 {
				w.constant = 20.0
			}
			return
		}
		stSpacing += 15.0
		if stSpacing > 120.0 {
			stSpacing = 0.0
		}
		theStacks.forEach { sv in
			sv.spacing = stSpacing
		}
		updateViews()
	}
		
	func reAddAfterViews() {
		
		guard let sv = theStacks.last,
			  let mViews = theMeasureViews.last
		else { return }
		
		sv.arrangedSubviews.forEach { v in
			v.removeFromSuperview()
			sv.addArrangedSubview(v)
		}
		for (mv, bv) in zip(mViews, sv.arrangedSubviews) {
			NSLayoutConstraint.activate([
				mv.leadingAnchor.constraint(equalTo: bv.leadingAnchor),
				mv.trailingAnchor.constraint(equalTo: bv.trailingAnchor),
			])
		}
	}
}

