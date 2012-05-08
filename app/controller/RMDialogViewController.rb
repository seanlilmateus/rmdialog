class RMDialogViewController < UIViewController
  def loadView
    super
  end
  
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    self.create_dialog
  end
    
  
  def create_dialog
    root = RMDialog.create(title:"Rubymotion Dialog", grouped:true) do
      # First Section with Name
      section(name: "Example Section") do

        label title:"Hello", value:"World"
      
        boolean title:"Music", value:true
        
        boolean title:"Video"
        
        float title:"Float Element", key:"slider", value:0.5
        
        decimal title:"decimal Element", key:"slider", value:0.5, fraction:2
        
        time title:"Time element", date: NSDate.date, key:"date1", mode: UIDatePickerModeTime
        
        elems = ["Ferrari", "McLaren", "Lotus"]
        radio items: elems, selected:0, title:"Array", action:'dance:'        
      end
      
      #second Section
      section(name:"Second Section") do
        component = [*1..12]
        component2 = ["A", "B"]
        picker items:[component, component2], value:"3 B", title:"Key"
        
        segment items:["Option 1", "Option 2", "Option 3"], selected:1, title:"Radio"
        
      end.footer = "More controls will be added."
      
      # Section without a name
      section do
        label title:"Crazy", value:"Shit"
        
        elems =  {"Ferrari"=>"FerrariObj", "McLaren"=>"McLarenObj", "Mercedes"=>"MercedesObj"}
        radio items:elems, selected:0, title:"Hash", action:'action:'
        
        # button
        button title:"login" do
          alert = UIAlertView.alloc.initWithTitle("I Alert you", 
                                          message:"Do you want to be alerted?",
                                         delegate: self,
                                cancelButtonTitle: "OK", 
                                otherButtonTitles:nil)
          alert.show    
        end
        
        
        badge title: "With a badge", value: 10  do
          background_color UIColor.redColor
          color UIColor.whiteColor
        end
        
        entry title:"Name", placeholder:"HELLO"
        
        entry title:"Password", placeholder:"YES", secure:true do
          key_type UIKeyboardTypeNumberPad
          key_appearance UIKeyboardAppearanceAlert
        end
      end
      
      # section Selection
      selection items:["Football", "Soccer", "Formula 1"], title:"Simple select"
      
      # Dynamic Sections
      dynamic_section title:"Default: loading", msg:"This is empty"
      
      dynamic_section title:"Normal: with elements" do |sec|
        sec.bind = "iterate:something"
        sec.elementTemplate = {"type" => "QLabelElement", "title" => "Something here" }
      end
    end
    
    root.bindToObject({"empty" => [], "something" => ["first", "second"]})
    
    navigation = RMDialogController.controllerWithNavigationForRoot(root)
    self.presentModalViewController(navigation, animated:false)
  end  
end