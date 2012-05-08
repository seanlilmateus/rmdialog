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
      section = RMDSection.new(title, &blck).section
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
    def initialize(title, &block)
      @section = title.nil? ?  QSection.alloc.init : QSection.alloc.initWithTitle(title[:name])
      instance_eval(&block)
    end
    
    def radio(h={})
      radio = case h[:items]
        when Hash
          QRadioElement.alloc.initWithDict(h[:items], selected:h[:selected], title:h[:title])
        when Array
          QRadioElement.alloc.initWithItems(h[:items], selected:h[:selected], title:h[:title])
        when String
          QRadioElement.alloc.initWithKey(h[:items])
        else
          QRadioElement.alloc.init
        end
      radio.controllerAction = h[:action] if h[:action]
      @section.addElement(radio)
      radio
    end
    
    def button(h={}, &blck)
      button = QButtonElement.alloc.initWithTitle(h[:title])
      button.controllerAction = h[:action] if h[:action]
      button.onSelected = -> { blck[] } if block_given?
      @section.addElement(button)
      button
    end
    
    def float(h={})
      slider = QFloatElement.alloc.initWithTitle(h[:title], value:h[:value])
      slider.key = h[:key]
      @section.addElement(slider)
      slider
    end

    def decimal(h={})
      slider = QDecimalElement.alloc.initWithTitle(h[:title], value:h[:value])
      slider.key = h[:key]
      slider.fractionDigits = h[:fraction]
      @section.addElement(slider)
      slider
    end
        
    def label(h={})
      label = QLabelElement.alloc.initWithTitle(h[:title], Value:h[:value])
      @section.addElement(label)
      label
    end
    
    def segment(h={}) # "Option 1", @"Option 2", @"Option 3"
      element = QSegmentedElement.alloc.initWithItems(h[:items], selected:h[:selected], title:h[:title])
      @section.addElement(element)
      element
    end
    
    def picker(h={}, &blck)
      element = QPickerElement.alloc.initWithTitle(h[:title], items:h[:items], value:h[:value])
      #element.onValueChanged = blck if block_given?
      section.addElement(element)
      element
    end
       
    def time(h={})
      timer = QDateTimeInlineElement.alloc.initWithTitle(h[:title], date:h[:date])
      timer.key = h[:key] if h[:key]
      timer.mode = h[:mode] if h[:mode]
      @section.addElement(timer)
      timer
    end
    
    def badge(h={}, &blck)
      badge = RMDBadge.alloc.initWithTitle(h[:title]||"", Value:h[:value].to_s||"0")
      @section.addElement(badge)
      badge.instance_eval(&blck) if block_given?
      badge
    end
        
    def entry(h={title:"", value:"", placeholder:"", secure:false}, &blck)
      entry = RMDEntry.alloc.initWithTitle(h[:title], Value:h[:value], Placeholder:h[:placeholder]) 
      entry.secureTextEntry = h[:secure]    
      @section.addElement(entry)
      entry.instance_eval(&blck) if block_given?
      entry
    end
        
    def boolean(hash={})
      bool = QBooleanElement.alloc.initWithTitle(hash[:title], BoolValue:hash[:value]||false)
      @section.addElement bool
      bool
    end
  end
end

class RMDialogController < QuickDialogController
  def action(sender)
    NSLog("Radio %@", sender.selected)
  end
end