//
//  ViewController.swift
//  BadProportionalStackViews
//
//  Created by Don Mag on 7/6/23.
//

import UIKit

class ViewController: UIViewController {
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
		mv.axis = .horizontal
		mv.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(mv)
		NSLayoutConstraint.activate([
			mv.topAnchor.constraint(equalTo: v.bottomAnchor, constant: 4.0),
			mv.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 0.0),
			mv.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: 0.0),
			//mv.heightAnchor.constraint(equalToConstant: 80.0),
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

class vstViewController: UIViewController {
	
	var labels: [UILabel] = []
	var leftLabels: [UILabel] = []
	var rightLabels: [UILabel] = []
	var mViews: [MeasureView] = []
	var calcHeightConstraints: [NSLayoutConstraint] = []
	
	var fSize: CGFloat = 15.0
	
	let leftStack = UIStackView()
	let rightStack = UIStackView()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide
		
		let strs: [String] = [
			"1", "1\n2", "1\n2\n3",
		]
		let colors: [UIColor] = [
			.systemRed, .systemGreen, .systemBlue,
		]

		[leftStack, rightStack].forEach { sv in
			sv.axis = .vertical
			sv.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(sv)
			for (s, c) in zip(strs, colors) {
				let l = UILabel()
				l.font = .systemFont(ofSize: fSize, weight: .regular)
				l.numberOfLines = 0
				l.textAlignment = .center
				l.text = s
				l.backgroundColor = c
				l.textColor = .white
				labels.append(l)
				if sv == leftStack {
					leftLabels.append(l)
				} else {
					rightLabels.append(l)
				}
				sv.addArrangedSubview(l)
				let mv = MeasureView()
				mViews.append(mv)
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
			mViews[i].leadingAnchor.constraint(equalTo: leftStack.trailingAnchor, constant: 8.0).isActive = true
			mViews[i+3].leadingAnchor.constraint(equalTo: mViews[i].trailingAnchor, constant: 8.0).isActive = true
			mViews[i+3].trailingAnchor.constraint(equalTo: rightStack.leadingAnchor, constant: -8.0).isActive = true
			let c = labels[i].heightAnchor.constraint(equalToConstant: 100.0)
			c.priority = .required - 1
			c.isActive = i < 2
			calcHeightConstraints.append(c)
		}
		for i in 1..<6 {
			mViews[i].widthAnchor.constraint(equalTo: mViews[0].widthAnchor).isActive = true
		}
		
		NSLayoutConstraint.activate([
			leftStack.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			leftStack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			leftStack.heightAnchor.constraint(equalToConstant: 600.0),
			leftStack.widthAnchor.constraint(equalToConstant: 80.0),

			rightStack.topAnchor.constraint(equalTo: leftStack.topAnchor),
			rightStack.heightAnchor.constraint(equalTo: leftStack.heightAnchor),
			rightStack.widthAnchor.constraint(equalTo: leftStack.widthAnchor),
		])
	
		rightStack.distribution = .fillProportionally
	
		leftStack.distribution = .fill
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateLeft()
	}
	func updateLeft() {
		
		let sumOfHeights = leftLabels.reduce(0) { $0 + $1.intrinsicContentSize.height }
		
		let svHeight: CGFloat = leftStack.frame.height - (leftStack.spacing * 2.0)

		for i in 0..<2 {
			calcHeightConstraints[i].constant = leftLabels[i].intrinsicContentSize.height / sumOfHeights * svHeight
		}
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let sp: CGFloat = 75.0
		leftStack.spacing = leftStack.spacing == sp ? 0.0 : sp
		rightStack.spacing = leftStack.spacing
		updateLeft()
	}
	
}

