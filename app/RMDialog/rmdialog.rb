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
  
  # QSection Wrapper
  class RMDSection
    attr_reader :section
    def init(title, &block)
      @section = title.nil? ?  QSection.alloc.init : QSection.alloc.initWithTitle(title[:name])
      instance_eval(&block)
      @section
    end
    
    def radio(h={})
      ele = case h[:items]
        when Hash
          QRadioElement.alloc.initWithDict(h[:items], selected:h[:selected], title:h[:title])
        when Array
          QRadioElement.alloc.initWithItems(h[:items], selected:h[:selected], title:h[:title])
        when String
          QRadioElement.alloc.initWithKey(h[:items])
        else
          QRadioElement.alloc.init
        end
      ele.controllerAction = h[:action] if h[:action]
      section.addElement(ele)
      ele
    end
    
    def button(h={}, &blck)
      ele = QButtonElement.alloc.initWithTitle(h[:title])
      ele.onSelected = blck if block_given? 
      section.addElement(ele)
      ele
    end
    
    def float(h={})
      ele = QFloatElement.alloc.initWithTitle(h[:title], value:h[:value])
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
    
    def segment(h={}) # "Option 1", @"Option 2", @"Option 3"
      ele = QSegmentedElement.alloc.initWithItems(h[:items], selected:h[:selected], title:h[:title])
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
        
    def boolean(hash={})
      ele = QBooleanElement.alloc.initWithTitle(hash[:title], BoolValue:hash[:value]||false)
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
