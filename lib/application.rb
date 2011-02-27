require 'rubygems'
require 'hotcocoa'
require 'gdocs4ruby'

# Replace the following code with your own hotcocoa code

class Application

  include HotCocoa
  
  def start
    application :name => "Docbrown" do |app|
      app.delegate = self

      window :size => [340, 180], :center => true, :view => :nolayout do |win|
        win.will_close { exit }

        win.view = layout_view(:layout => {:expand => [:width, :height],
            :padding => 0, :margin => 0}) do |vert|

          vert << layout_view(:frame => [0, 0, 0, 40], :mode => :horizontal,
                             :layout => {:padding => 0, :margin => 0,
                             :start => false, :expand => [:width]}) do |horiz|

            horiz << label(:text => "User:", :layout => {:align => :center})

            horiz << @@user_field = text_field(:layout => {:expand => :width})
          end

          vert << layout_view(:frame => [0, 0, 0, 40], :mode => :horizontal,
                             :layout => {:padding => 0, :margin => 0,
                             :start => false, :expand => [:width]}) do |horiz|

            horiz << label(:text => "Password:", :layout => {:align => :center})
            horiz << @@password = secure_text_field(:frame => [0, 0, 0, 20], :layout => {:expand => :width})


          end

          vert << @l1 = layout_view(:frame => [0, 0, 0, 40], :mode => :horizontal,
                             :layout => {:padding => 0, :margin => 0,
                             :start => false, :expand => [:width]}) do |horiz|

            horiz << button(:title => "Go", :layout => {:align => :center}) do |b|
              b.on_action { show_docs }
                # Code to button click
            end
          end
        end
      end
    end
  end

  def show_docs
    window :size => [640,480], :center => true do |win|
      win.view = layout_view(:layout => {:expand => [:width, :height],
          :padding => 0, :margin => 0}) do |vert|

        vert << scroll_view(:layout => {:expand => [:width, :height]}) do |scroll|
          scroll.setAutohidesScrollers(true)
          scroll << @table = table_view(:columns => [column(:id => :data, :title => '')],
                                        :data => []) do |table|
             table.setUsesAlternatingRowBackgroundColors(true)
             table.setGridStyleMask(NSTableViewSolidHorizontalGridLineMask)                             
          end
        end
      end
      #win.setHidden(true)
    end

    service = GDocs4Ruby::Service.new
    service.authenticate(@@user_field.stringValue, @@password.stringValue)
    documents = service.files
    titles = documents.collect(&:title)

    titles.each do |doc|
      @table.dataSource.data << { :data => doc }
    end

    @table.reloadData
  end
  
  # file/open
  def on_open(menu)
  end
  
  # file/new 
  def on_new(menu)
  end
  
  # help menu item
  def on_help(menu)
  end
  
  # This is commented out, so the minimize menu item is disabled
  #def on_minimize(menu)
  #end
  
  # window/zoom
  def on_zoom(menu)
  end
  
  # window/bring_all_to_front
  def on_bring_all_to_front(menu)
  end
end

Application.new.start
