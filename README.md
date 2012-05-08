## Description
RMDialog is based on [QuickDialog](https://github.com/escoz/QuickDialog/), it means that you will need to embed the QuickDialog in your project for RMDialog to run.
Since I still studying the QuickDialog classes and some features are buggy or not present yet. 
I'll welcome any contribution, so feel free to extend, correct any code in this project by pulling a request.


```ruby
	# create a RMDialog with a title, and grouped
    root = RMDialog.create(title:"Rubymotion Dialog", grouped:true) do
		# create a new section 
		section(name: "Example Section") do
			label title:"Hello", value:"world"
		end
	end
```

## Hierarchy
- root: RMDialog.create({}, &block), create a **QRootElement** 
	- section: create and adds a **QSection** to the root
		- label: create and add a **QLabelElement** to the section
		- float: 
		- boolean:
		- decimal:
		- badge:
		- button:
		- label:
	- selection
	- dynamic_section

## Todo List
- every action on **boolean**, **button**, **decimal** and more should be captured in a block e.g.:

	```ruby

		button(title:"login") do	
			alert = alert.alloc.init
			alert.message = "Hello World"
			alert.show
		end

		decimal(title:"decimal Element", key:"slider", value:0.5, fraction:2) do |value|
			alert = alert.alloc.init
			alert.message = "decimal #{value}"
			alert.show
		end
	```
- Documentation
- Create Dialog from Json data
- Design discussion (are we creating to much objects?)
- QuickDialog Elements:
	- QTextElement
	- QLoadingElement
	- QDateTimeElement
	- QMapElement
		- QMapAnnotation
	- QSortingSection
	- QWebElement
	- QMultilineElement
	- QLoadingElement
	- more ...
- Element Customization design 

## Thanks
I'd just like to thank [escoz](https://github.com/escoz) and all [QuickDialog](https://github.com/escoz/QuickDialog) contributors for the great library

