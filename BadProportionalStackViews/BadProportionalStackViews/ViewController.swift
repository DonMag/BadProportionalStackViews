//
//  ViewController.swift
//  BadProportionalStackViews
//
//  Created by Don Mag on 7/6/23.
//

import UIKit

class tViewController: UIViewController {
	let v = IntrinsicView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		v.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(v)
		let g = view.safeAreaLayoutGuide
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

class szViewController: UIViewController {

	var labels: [UILabel] = []
	var mViews: [MeasureView] = []
	
	var fSize: CGFloat = 15.0

	override func viewDidLoad() {
		super.viewDidLoad()

		let g = view.safeAreaLayoutGuide

		let strs: [String] = [
			"1", "1\n2", "1\n2\n3",
		]
		let colors: [UIColor] = [
			.systemRed, .systemGreen, .systemBlue,
		]
		
		for (s, c) in zip(strs, colors) {
			let l = UILabel()
			l.font = .systemFont(ofSize: fSize, weight: .regular)
			l.numberOfLines = 0
			l.textAlignment = .center
			l.text = s
			l.backgroundColor = c
			l.textColor = .white
			labels.append(l)
			let mv = MeasureView()
			mViews.append(mv)
			l.translatesAutoresizingMaskIntoConstraints = false
			mv.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(l)
			view.addSubview(mv)
			NSLayoutConstraint.activate([
				l.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
				l.widthAnchor.constraint(equalToConstant: 60.0),
				mv.topAnchor.constraint(equalTo: l.topAnchor),
				mv.bottomAnchor.constraint(equalTo: l.bottomAnchor),
				mv.leadingAnchor.constraint(equalTo: l.trailingAnchor, constant: 8.0),
			])
		}
		labels[0].leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 40.0).isActive = true
		labels[1].leadingAnchor.constraint(equalTo: mViews[0].trailingAnchor, constant: 20.0).isActive = true
		labels[2].leadingAnchor.constraint(equalTo: mViews[1].trailingAnchor, constant: 20.0).isActive = true
		
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		fSize += 1
		labels.forEach { v in
			v.font = .systemFont(ofSize: fSize, weight: .regular)
		}
		print(fSize)
	}

}

class vViewController: UIViewController {
	
	let aStack = UIStackView()
	let bStack = UIStackView()

	var stSpacing: CGFloat = 0.0
	
	var aViews: [UIView] = []
	var bViews: [UIView] = []
	var measureViews: [MeasureView] = []
	var calcConstraints: [NSLayoutConstraint] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide
		
		let strs: [String] = [
			"1", "1\n2", "1\n2\n3",
		]
		let colors: [UIColor] = [
			.systemRed, .systemGreen, .systemBlue,
		]

		[aStack, bStack].forEach { sv in
			sv.axis = .vertical
			sv.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(sv)
			for (s, c) in zip(strs, colors) {
				let l = UILabel()
				l.font = .monospacedSystemFont(ofSize: 15, weight: .regular)
				l.numberOfLines = 0
				l.textAlignment = .center
				l.text = s
				l.backgroundColor = c
				l.textColor = .white
				if sv == aStack {
					aViews.append(l)
				} else {
					bViews.append(l)
				}
				sv.addArrangedSubview(l)
				let mv = MeasureView()
				mv.axis = .vertical
				measureViews.append(mv)
				mv.translatesAutoresizingMaskIntoConstraints = false
				view.addSubview(mv)
				NSLayoutConstraint.activate([
					mv.topAnchor.constraint(equalTo: l.topAnchor),
					mv.bottomAnchor.constraint(equalTo: l.bottomAnchor),
				])
			}
		}
		for i in 0..<3 {
			measureViews[i].leadingAnchor.constraint(equalTo: aStack.trailingAnchor, constant: 8.0).isActive = true
			measureViews[i+3].leadingAnchor.constraint(equalTo: measureViews[i].trailingAnchor, constant: 24.0).isActive = true
			measureViews[i+3].trailingAnchor.constraint(equalTo: bStack.leadingAnchor, constant: -8.0).isActive = true
		}
		for i in 0..<2 {
			let c = aViews[i].heightAnchor.constraint(equalToConstant: 100.0)
			c.priority = .required - 1
			c.isActive = true
			calcConstraints.append(c)
		}
		for i in 1..<6 {
			measureViews[i].widthAnchor.constraint(equalTo: measureViews[0].widthAnchor).isActive = true
		}
		
		NSLayoutConstraint.activate([
			aStack.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			aStack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			aStack.heightAnchor.constraint(equalToConstant: 600.0),
			aStack.widthAnchor.constraint(equalToConstant: 80.0),

			bStack.topAnchor.constraint(equalTo: aStack.topAnchor),
			bStack.heightAnchor.constraint(equalTo: aStack.heightAnchor),
			bStack.widthAnchor.constraint(equalTo: aStack.widthAnchor),
		])
	
		bStack.distribution = .fillProportionally
	
		aStack.distribution = .fill
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateLeft()
	}
	func updateLeft() {
		
		let sumOfHeights = aViews.reduce(0) { $0 + $1.intrinsicContentSize.height }
		
		let svHeight: CGFloat = aStack.frame.height - (aStack.spacing * 2.0)

		for i in 0..<2 {
			calcConstraints[i].constant = aViews[i].intrinsicContentSize.height / sumOfHeights * svHeight
		}
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		stSpacing += 15.0
		if stSpacing > 120.0 {
			stSpacing = 0.0
		}
		aStack.spacing = stSpacing
		bStack.spacing = stSpacing
		updateLeft()
	}
	
}

class hViewController: UIViewController {
	
	let aStack = UIStackView()
	let bStack = UIStackView()
	
	var stSpacing: CGFloat = 0.0
	
	var aViews: [UIView] = []
	var bViews: [UIView] = []
	var measureViews: [MeasureView] = []
	var calcConstraints: [NSLayoutConstraint] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide
		
		let strs: [String] = [
			"1", "12", "123",
		]
		let colors: [UIColor] = [
			.systemRed, .systemGreen, .systemBlue,
		]
		
		[aStack, bStack].forEach { sv in
			sv.axis = .horizontal
			sv.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(sv)
			for (s, c) in zip(strs, colors) {
				let l = UILabel()
				l.font = .monospacedSystemFont(ofSize: 15, weight: .regular)
				l.textAlignment = .center
				l.text = s
				l.backgroundColor = c
				l.textColor = .white
				if sv == aStack {
					aViews.append(l)
				} else {
					bViews.append(l)
				}
				sv.addArrangedSubview(l)
				let mv = MeasureView()
				mv.axis = .horizontal
				measureViews.append(mv)
				mv.translatesAutoresizingMaskIntoConstraints = false
				view.addSubview(mv)
				NSLayoutConstraint.activate([
					mv.leadingAnchor.constraint(equalTo: l.leadingAnchor),
					mv.trailingAnchor.constraint(equalTo: l.trailingAnchor),
				])
			}
		}
		for i in 0..<3 {
			measureViews[i].topAnchor.constraint(equalTo: aStack.bottomAnchor, constant: 8.0).isActive = true
			measureViews[i+3].topAnchor.constraint(equalTo: measureViews[i].bottomAnchor, constant: 24.0).isActive = true
			measureViews[i+3].bottomAnchor.constraint(equalTo: bStack.topAnchor, constant: -8.0).isActive = true
		}
		for i in 0..<2 {
			let c = aViews[i].widthAnchor.constraint(equalToConstant: 100.0)
			c.priority = .required - 1
			c.isActive = true
			calcConstraints.append(c)
		}
		for i in 1..<6 {
			measureViews[i].heightAnchor.constraint(equalTo: measureViews[0].heightAnchor).isActive = true
		}
		
		NSLayoutConstraint.activate([
			aStack.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			aStack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			aStack.heightAnchor.constraint(equalToConstant: 60.0),
			aStack.widthAnchor.constraint(equalToConstant: 600.0),
			
			bStack.leadingAnchor.constraint(equalTo: aStack.leadingAnchor),
			bStack.heightAnchor.constraint(equalTo: aStack.heightAnchor),
			bStack.widthAnchor.constraint(equalTo: aStack.widthAnchor),
		])
		
		bStack.distribution = .fillProportionally
		
		aStack.distribution = .fill
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateLeft()
	}
	func updateLeft() {
		
		let sumOfWidths = aViews.reduce(0) { $0 + $1.intrinsicContentSize.width }
		
		let svWidth: CGFloat = aStack.frame.width - (aStack.spacing * 2.0)
		
		for i in 0..<2 {
			calcConstraints[i].constant = aViews[i].intrinsicContentSize.width / sumOfWidths * svWidth
		}
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		stSpacing += 15.0
		if stSpacing > 120.0 {
			stSpacing = 0.0
		}
		aStack.spacing = stSpacing
		bStack.spacing = stSpacing
		updateLeft()
	}
	
}



class MyBaseViewController: UIViewController {
	
	let aStack = UIStackView()
	let bStack = UIStackView()
	
	var stSpacing: CGFloat = 0.0
	
	var aViews: [UIView] = []
	var bViews: [UIView] = []
	var aMeasureViews: [MeasureView] = []
	var bMeasureViews: [MeasureView] = []
	var measureViews: [MeasureView] = []
	var calcConstraints: [NSLayoutConstraint] = []
	
	let colors: [UIColor] = [
		.systemRed, .systemGreen, .systemBlue,
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		for _ in 0..<6 {
//			let mv = MeasureView()
//			mv.translatesAutoresizingMaskIntoConstraints = false
//			measureViews.append(mv)
//			view.addSubview(mv)
//		}
		for _ in 0..<3 {
			let mvA = MeasureView()
			mvA.translatesAutoresizingMaskIntoConstraints = false
			aMeasureViews.append(mvA)
			view.addSubview(mvA)
			let mvB = MeasureView()
			mvB.translatesAutoresizingMaskIntoConstraints = false
			bMeasureViews.append(mvB)
			view.addSubview(mvB)
		}

		[aStack, bStack].forEach { sv in
			sv.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(sv)
		}

	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateAViews()
	}

	func updateAViews() {
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		stSpacing += 15.0
		if stSpacing > 120.0 {
			stSpacing = 0.0
		}
		aStack.spacing = stSpacing
		bStack.spacing = stSpacing
		updateAViews()
	}
	
}

class HorizontalLabelsVC: MyBaseViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide
		
		let strs: [String] = [
			"1", "12", "123",
		]
		
		[aStack, bStack].forEach { sv in
			sv.axis = .horizontal
			for (s, c) in zip(strs, colors) {
				let l = UILabel()
				l.font = .monospacedSystemFont(ofSize: 16, weight: .regular)
				l.textAlignment = .center
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
		for i in 0..<3 {
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
		for i in 0..<2 {
			let c = aViews[i].widthAnchor.constraint(equalToConstant: 100.0)
			c.priority = .required - 1
			c.isActive = true
			calcConstraints.append(c)
		}
		
		NSLayoutConstraint.activate([
			aStack.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			aStack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			aStack.heightAnchor.constraint(equalToConstant: 60.0),
			aStack.widthAnchor.constraint(equalToConstant: 600.0),
			
			bStack.leadingAnchor.constraint(equalTo: aStack.leadingAnchor),
			bStack.heightAnchor.constraint(equalTo: aStack.heightAnchor),
			bStack.widthAnchor.constraint(equalTo: aStack.widthAnchor),
		])
		
		aStack.distribution = .fill
		bStack.distribution = .fillProportionally
		
	}

	override func updateAViews() {
		super.updateAViews()
		
		let sumOfWidths = aViews.reduce(0) { $0 + $1.intrinsicContentSize.width }
		
		let svWidth: CGFloat = aStack.frame.width - (aStack.spacing * 2.0)
		
		for i in 0..<2 {
			calcConstraints[i].constant = aViews[i].intrinsicContentSize.width / sumOfWidths * svWidth
		}
		
	}

}

class HorizontalViewsVC: MyBaseViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide
		
		let vals: [CGFloat] = [
			1.0, 2.0, 3.0
		]
		
		[aStack, bStack].forEach { sv in
			sv.axis = .horizontal
			for (val, c) in zip(vals, colors) {
				let v = IntrinsicView()
				v.myIntrinsicSize = .init(width: val, height: 0.0)
				v.backgroundColor = c
				if sv == aStack {
					aViews.append(v)
				} else {
					bViews.append(v)
				}
				sv.addArrangedSubview(v)
			}
		}
		for i in 0..<3 {
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
		for i in 0..<2 {
			let c = aViews[i].widthAnchor.constraint(equalToConstant: 100.0)
			c.priority = .required - 1
			c.isActive = true
			calcConstraints.append(c)
		}
		
		NSLayoutConstraint.activate([
			aStack.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			aStack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			aStack.heightAnchor.constraint(equalToConstant: 60.0),
			aStack.widthAnchor.constraint(equalToConstant: 600.0),
			
			bStack.leadingAnchor.constraint(equalTo: aStack.leadingAnchor),
			bStack.heightAnchor.constraint(equalTo: aStack.heightAnchor),
			bStack.widthAnchor.constraint(equalTo: aStack.widthAnchor),
		])
		
		aStack.distribution = .fill
		bStack.distribution = .fillProportionally
		
	}
	
	override func updateAViews() {
		super.updateAViews()
		
		let sumOfWidths = aViews.reduce(0) { $0 + $1.intrinsicContentSize.width }
		
		let svWidth: CGFloat = aStack.frame.width - (aStack.spacing * 2.0)
		
		for i in 0..<2 {
			calcConstraints[i].constant = aViews[i].intrinsicContentSize.width / sumOfWidths * svWidth
		}
		
	}
	
}

class VerticalLabelsVC: MyBaseViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide
		
		let strs: [String] = [
			"1", "1\n2", "1\n2\n3",
		]
		
		[aStack, bStack].forEach { sv in
			sv.axis = .vertical
			for (s, c) in zip(strs, colors) {
				let l = UILabel()
				l.font = .monospacedSystemFont(ofSize: 15, weight: .regular)
				l.textAlignment = .center
				l.numberOfLines = 0
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
		for i in 0..<3 {
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
		for i in 0..<2 {
			let c = aViews[i].heightAnchor.constraint(equalToConstant: 100.0)
			c.priority = .required - 1
			c.isActive = true
			calcConstraints.append(c)
		}
		
		NSLayoutConstraint.activate([
			aStack.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			aStack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			aStack.heightAnchor.constraint(equalToConstant: 600.0),
			aStack.widthAnchor.constraint(equalToConstant: 80.0),
			
			bStack.topAnchor.constraint(equalTo: aStack.topAnchor),
			bStack.heightAnchor.constraint(equalTo: aStack.heightAnchor),
			bStack.widthAnchor.constraint(equalTo: aStack.widthAnchor),
		])
		
		aStack.distribution = .fill
		bStack.distribution = .fillProportionally

	}
	
	override func updateAViews() {
		super.updateAViews()
		
		let sumOfHeights = aViews.reduce(0) { $0 + $1.intrinsicContentSize.height }
		
		let svHeight: CGFloat = aStack.frame.height - (aStack.spacing * 2.0)
		
		for i in 0..<2 {
			calcConstraints[i].constant = aViews[i].intrinsicContentSize.height / sumOfHeights * svHeight
		}
		
	}
	
}

class VerticalViewsVC: MyBaseViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide
		
		let vals: [CGFloat] = [
			1.0, 2.0, 3.0
		]
		
		[aStack, bStack].forEach { sv in
			sv.axis = .vertical
			for (val, c) in zip(vals, colors) {
				let v = IntrinsicView()
				v.myIntrinsicSize = .init(width: 0.0, height: val)
				v.backgroundColor = c
				if sv == aStack {
					aViews.append(v)
				} else {
					bViews.append(v)
				}
				sv.addArrangedSubview(v)
			}
		}
		for i in 0..<3 {
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
		for i in 0..<2 {
			let c = aViews[i].heightAnchor.constraint(equalToConstant: 100.0)
			c.priority = .required - 1
			c.isActive = true
			calcConstraints.append(c)
		}
		
		NSLayoutConstraint.activate([
			aStack.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			aStack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			aStack.heightAnchor.constraint(equalToConstant: 600.0),
			aStack.widthAnchor.constraint(equalToConstant: 80.0),
			
			bStack.topAnchor.constraint(equalTo: aStack.topAnchor),
			bStack.heightAnchor.constraint(equalTo: aStack.heightAnchor),
			bStack.widthAnchor.constraint(equalTo: aStack.widthAnchor),
		])
		
		aStack.distribution = .fill
		bStack.distribution = .fillProportionally
		
	}
	
	override func updateAViews() {
		super.updateAViews()
		
		let sumOfHeights = aViews.reduce(0) { $0 + $1.intrinsicContentSize.height }
		
		let svHeight: CGFloat = aStack.frame.height - (aStack.spacing * 2.0)
		
		for i in 0..<2 {
			calcConstraints[i].constant = aViews[i].intrinsicContentSize.height / sumOfHeights * svHeight
		}
		
	}
	
}
