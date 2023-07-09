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

class MenuViewController: UIViewController {
	
	
	
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
		.systemRed, .systemGreen, .systemBlue, .systemYellow
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for _ in 0..<colors.count {
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

		aStack.distribution = .fill
		bStack.distribution = .fillProportionally
		
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
		
		var strs: [String] = []
		var s: String = ""
		for i in 1...colors.count {
			s += "\(i)"
			strs.append(s)
		}
		
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
		
		for i in 0..<(aViews.count - 1) {
			calcConstraints[i].constant = aViews[i].intrinsicContentSize.width / sumOfWidths * svWidth
		}
		
	}

}

class HorizontalViewsVC: MyBaseViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide
		
		var vals: [CGFloat] = []
		for i in 1...colors.count {
			vals.append(CGFloat(i))
		}

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
		
		NSLayoutConstraint.activate([
			aStack.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			aStack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			aStack.heightAnchor.constraint(equalToConstant: 60.0),
			aStack.widthAnchor.constraint(equalToConstant: 600.0),
			
			bStack.leadingAnchor.constraint(equalTo: aStack.leadingAnchor),
			bStack.heightAnchor.constraint(equalTo: aStack.heightAnchor),
			bStack.widthAnchor.constraint(equalTo: aStack.widthAnchor),
		])
		
	}
	
	override func updateAViews() {
		super.updateAViews()
		
		let sumOfWidths = aViews.reduce(0) { $0 + $1.intrinsicContentSize.width }
		
		let svWidth: CGFloat = aStack.frame.width - (aStack.spacing * 2.0)
		
		for i in 0..<(aViews.count - 1) {
			calcConstraints[i].constant = aViews[i].intrinsicContentSize.width / sumOfWidths * svWidth
		}
		
	}
	
}

class VerticalLabelsVC: MyBaseViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide
		
		var strs: [String] = []
		var s: String = "1"
		strs.append(s)
		for i in 2...colors.count {
			s += "\n\(i)"
			strs.append(s)
		}

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
		
		NSLayoutConstraint.activate([
			aStack.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			aStack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			aStack.heightAnchor.constraint(equalToConstant: 600.0),
			aStack.widthAnchor.constraint(equalToConstant: 80.0),
			
			bStack.topAnchor.constraint(equalTo: aStack.topAnchor),
			bStack.heightAnchor.constraint(equalTo: aStack.heightAnchor),
			bStack.widthAnchor.constraint(equalTo: aStack.widthAnchor),
		])
		
	}
	
	override func updateAViews() {
		super.updateAViews()
		
		let sumOfHeights = aViews.reduce(0) { $0 + $1.intrinsicContentSize.height }
		
		let svHeight: CGFloat = aStack.frame.height - (aStack.spacing * 2.0)
		
		for i in 0..<(aViews.count - 1) {
			calcConstraints[i].constant = aViews[i].intrinsicContentSize.height / sumOfHeights * svHeight
		}
		
	}
	
}

class VerticalViewsVC: MyBaseViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide
		
		var vals: [CGFloat] = []
		for i in 1...colors.count {
			vals.append(CGFloat(i))
		}
		
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
		
		NSLayoutConstraint.activate([
			aStack.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			aStack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			aStack.heightAnchor.constraint(equalToConstant: 600.0),
			aStack.widthAnchor.constraint(equalToConstant: 80.0),
			
			bStack.topAnchor.constraint(equalTo: aStack.topAnchor),
			bStack.heightAnchor.constraint(equalTo: aStack.heightAnchor),
			bStack.widthAnchor.constraint(equalTo: aStack.widthAnchor),
		])
		
	}
	
	override func updateAViews() {
		super.updateAViews()
		
		let sumOfHeights = aViews.reduce(0) { $0 + $1.intrinsicContentSize.height }
		
		let svHeight: CGFloat = aStack.frame.height - (aStack.spacing * 2.0)
		
		for i in 0..<(aViews.count - 1) {
			calcConstraints[i].constant = aViews[i].intrinsicContentSize.height / sumOfHeights * svHeight
		}
		
	}
	
}
