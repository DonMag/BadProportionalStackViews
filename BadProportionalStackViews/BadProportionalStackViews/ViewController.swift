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

class ViewController: UIViewController {
	
	let aStack = UIStackView()
	let bStack = UIStackView()

	var stSpacing: CGFloat = 0.0
	
	var aLabels: [UILabel] = []
	var bLabels: [UILabel] = []
	var measureViews: [MeasureView] = []
	var calcHeightConstraints: [NSLayoutConstraint] = []
	
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
					aLabels.append(l)
				} else {
					bLabels.append(l)
				}
				sv.addArrangedSubview(l)
				let mv = MeasureView()
				measureViews.append(mv)
				mv.translatesAutoresizingMaskIntoConstraints = false
				view.addSubview(mv)
				let c1 = mv.topAnchor.constraint(equalTo: l.topAnchor)
				let c2 = mv.bottomAnchor.constraint(equalTo: l.bottomAnchor)
				c1.priority = .required - 1
				c2.priority = .required - 1
				NSLayoutConstraint.activate([
					c1, c2
				])
			}
		}
		for i in 0..<3 {
			measureViews[i].leadingAnchor.constraint(equalTo: aStack.trailingAnchor, constant: 8.0).isActive = true
			measureViews[i+3].leadingAnchor.constraint(equalTo: measureViews[i].trailingAnchor, constant: 24.0).isActive = true
			measureViews[i+3].trailingAnchor.constraint(equalTo: bStack.leadingAnchor, constant: -8.0).isActive = true
			let c = aLabels[i].heightAnchor.constraint(equalToConstant: 100.0)
			c.priority = .required - 1
			c.isActive = i < 2
			calcHeightConstraints.append(c)
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
		
		let sumOfHeights = aLabels.reduce(0) { $0 + $1.intrinsicContentSize.height }
		
		let svHeight: CGFloat = aStack.frame.height - (aStack.spacing * 2.0)

		for i in 0..<2 {
			calcHeightConstraints[i].constant = aLabels[i].intrinsicContentSize.height / sumOfHeights * svHeight
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


