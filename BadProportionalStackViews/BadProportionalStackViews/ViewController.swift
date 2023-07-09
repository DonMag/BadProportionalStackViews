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
		stackView.spacing = 40
		
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

class DemoViewController: UIViewController {
	
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
	}
	
	var cSize: CGSize = .init(width: -1.0, height: -1.0)
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if cSize != containerView.frame.size {
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
	
}

