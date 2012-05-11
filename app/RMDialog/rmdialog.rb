module RMDialog
  def self.create(hash={}, &block)
    root = Root.new(hash, &block).root
  end
  
  class Root
    attr_reader :root
    # create a root QRootElement
    def initialize(h={}, &block)
      @root = QRootElement.alloc.init
      @root.grouped = h[:grouped] if h[:grouped]
      @root.title = h[:title] if h[:grouped]
      instance_eval(&block)
    end
    
    # create a QSection
    def section(title = nil, &blck)
      section = RMDSection.alloc.init(title, &blck)
      @root.addSection(section)
      section
    end
    
    # create a QSelectSection
    def selection(h={indexes: nil}, &blck)
      section = QSelectSection.alloc.initWithItems(h[:items], selectedIndexes:h[:selected], title:h[:title])
      section.multipleAllowed = h[:multi] if h[:multi]
      @root.addSection(section)
      section.instance_eval(&blck) if block_given?
      section
    end
    
    # create an QDynamicDataSection
    def dynamic_section(h={}, &blck)
      dyn_section = QDynamicDataSection.new
      dyn_section.title = h[:title]
      dyn_section.emptyMessage = h[:msg] if h[:msg]
      blck[dyn_section] if block_given?
      @root.addSection(dyn_section)
      dyn_section
    end  
  end
  
  
  class RMDBadge < QBadgeElement
    def background_color(color)
      self.badgeColor = color
    end
    
    def color(color)
      self.badgeTextColor = color
    end    
  end
    
  # QEntryElement wrapper example
  class RMDEntry < QEntryElement
    def key_type(type)
      self.keyboardType = type
    end
    
    def key_appearance(appearance)
      self.keyboardAppearance = appearance
    end
  end
  
  class RMQBooleanElement < QBooleanElement
    def block=(value); @block = value; end
    def switched(bool_switch)
      @block[bool_switch.isOn] #isOn
      super
    end
  end
  
  class RMQRadioElement < QRadioElement
    attr_accessor :block
    def setSelected(a_selected)
      @block[self.items[a_selected]] if @block
      super
    end
  end
  
  class RMQFloatElement < QLabelElement
    attr_accessor :float_value, :block
    
    def initWithTitle(title, Value:value)
      if super(title, nil)
        @float_value = value
      end
      self
    end
    
    def initWithValue(value)
      if init
        @float_value = value
      end
      self
    end
    
    def fetchValueIntoObject(obj)
      return if self.key.nil?
      obj.setValue(@float_value, forKey:self.key)
    end
    
    def calculateSliderWidth(view, cell:cell)
      return view.contentSize.width - 40 if self.title.nil?
      view.contentSize.width - cell.textLabel.text.sizeWithFont(UIFont.boldSystemFontOfSize(17)).width - 50
    end
    
    def value_changed(slider)
      @block[slider.value]
      @float_value = slider.value
    end
    
    def getCellForTableView(tableView, controller:controller)
        cell = super
        slider = UISlider.alloc.initWithFrame CGRectMake(0, 0, self.calculateSliderWidth(tableView, cell:cell), 20)
        slider.addTarget(self, action:'value_changed:', forControlEvents:UIControlEventValueChanged)
        slider.autoresizingMask = UIViewAutoresizingFlexibleWidth
        slider.value = @float_value
        cell.accessoryView = slider
        cell
    end
  end
  
  class RMQSegmentedElement < QSegmentedElement
    def block=(value); @block = value; end
    def handle_segmented(control)
      handleSegmentedControlValueChanged(control)
      @block[self.items[self.selected]]
    end
    
    def getCellForTableView(tableView, controller:controller)
       super
       cell = QTableViewCell.alloc.init
       cell.backgroundView = UIView.alloc.initWithFrame CGRectMake(0, 0, 0, 0)
       cell.backgroundColor = UIColor.clearColor
       control = UISegmentedControl.alloc.initWithItems(self.items)
       control.addTarget(self, action:'handle_segmented:', forControlEvents:UIControlEventValueChanged)
       control.frame = CGRectMake(9, 0, 302, 46);
       control.segmentedControlStyle = UISegmentedControlStyleBar
       control.selectedSegmentIndex = self.selected

       cell.addSubview(control)
       cell
    end
  end
  # QSection Wrapper
  class RMDSection
    attr_reader :section
    def init(title, &block)
      @section = title.nil? ?  QSection.alloc.init : QSection.alloc.initWithTitle(title[:name])
      instance_eval(&block)
      @section
    end
    
    def radio(h={}, &blck)
      ele = case h[:items]
        when Hash
          RMQRadioElement.alloc.initWithDict(h[:items], selected:h[:selected], title:h[:title])
        when Array
          RMQRadioElement.alloc.initWithItems(h[:items], selected:h[:selected], title:h[:title])
        when String
          RMQRadioElement.alloc.initWithKey(h[:items])
        else
          RMQRadioElement.alloc.init
        end
      
      ele.block = blck if block_given?      
      section.addElement(ele)
      ele
    end
    
    def button(h={}, &blck)
      ele = QButtonElement.alloc.initWithTitle(h[:title])
      ele.onSelected = blck if block_given? 
      section.addElement(ele)
      ele
    end
    
    def float(h={}, &blck)
      ele = RMQFloatElement.alloc.initWithTitle(h[:title], Value:h[:value])
      ele.block = blck if block_given?
      ele.key = h[:key]
      section.addElement(ele)
      ele
    end

    def decimal(h={})
      ele = QDecimalElement.alloc.initWithTitle(h[:title], value:h[:value])
      ele.key = h[:key]
      ele.fractionDigits = h[:fraction]
      section.addElement(ele)
      ele
    end
        
    def label(h={})
      ele = QLabelElement.alloc.initWithTitle(h[:title], Value:h[:value])
      section.addElement(ele)
      ele
    end
    
    def segment(h={}, &blck) # "Option 1", @"Option 2", @"Option 3"
      ele = RMQSegmentedElement.alloc.initWithItems(h[:items], selected:h[:selected], title:h[:title])
      ele.block = blck if block_given?
      section.addElement(ele)
      ele
    end
    
    def picker(h={}, &blck)
      ele = QPickerElement.alloc.initWithTitle(h[:title], items:h[:items], value:h[:value])
      #ele.onValueChanged = blck if block_given?
      section.addElement(ele)
      ele
    end
       
    def time(h={})
      ele = QDateTimeInlineElement.alloc.initWithTitle(h[:title], date:h[:date])
      ele.key = h[:key] if h[:key]
      ele.mode = h[:mode] if h[:mode]
      section.addElement(ele)
      ele
    end
    
    def badge(h={}, &blck)
      ele = RMDBadge.alloc.initWithTitle(h[:title]||"", Value:h[:value].to_s||"0")
      section.addElement(ele)
      ele.instance_eval(&blck) if block_given?
      ele
    end
        
    def entry(h={title:"", value:"", placeholder:"", secure:false}, &blck)
      ele = RMDEntry.alloc.initWithTitle(h[:title], Value:h[:value], Placeholder:h[:placeholder]) 
      ele.secureTextEntry = h[:secure]    
      section.addElement(ele)
      ele.instance_eval(&blck) if block_given?
      ele
    end
        
    def boolean(hash={}, &blck)
      ele = RMQBooleanElement.alloc.initWithTitle(hash[:title], BoolValue:hash[:value]||false)
      ele.block = blck if block_given?
      section.addElement(ele)
      ele
    end
  end
end

class RMDialogController < QuickDialogController
  def action(sender)
    NSLog("Radio %@", sender.selected)
  end
end
