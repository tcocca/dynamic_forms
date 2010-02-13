# Adds the FormBuilder#check_box_group method
module DynamicForms
  module CheckBoxGroupHelper
  
    def self.included(base)
      ActionView::Helpers::FormBuilder.send :include, InstanceMethods
    end
    
    module InstanceMethods
    
      # FormBuilder helper method that gives the user a group of checkboxes.
      # 
      # Arguments:
      #   name: attribute name, as with most FormBuilder helpers
      #   full_collection: an array of all the possible values (one checkbox displayed for each)
      #   options:
      #     :source - explicitly pass an array of selected objects, or a method name as a 
      #               symbol that will return an array
      # 
      # By default, this method will output a list of checkboxes with labels. If custom behavior
      # is needed, a block can be passed that takes two block parameters (the input markup and 
      # the object represented by the checkbox).
      # 
      # Examples:
      # 
      #   # Examples assume
      #   # f.object.favorite_colors #=> ['red', 'blue']
      #   # COLORS = ['red', 'orange', 'yellow', 'green', 'blue']
      # 
      #   # This will output five checkboxes, with 'red' and 'blue' checked
      #   <%= f.check_box_group(:favorite_colors, COLORS) %>
      # 
      #   # Use :source if getter and setter are named differently
      #   <%= f.check_box_group(:color_setter, COLORS, :source => :favorite_colors) %>
      # 
      #   # Use a block for custom formatting
      #   <p id="special_checkbox_list">
      #     <% f.checkbox_group(:favorite_colors, COLORS) do |input, color| %>
      #       <span><label><%= color %></label> <%= input %></span>
      #     <% end %>
      #   </p>
      # 
      def check_box_group(name, full_collection, options={}, &block)
        options[:source] ||= name.to_sym
        
        # collection of currently 'checked' objects
        obj_collection = case options[:source]
          when Symbol: @object.send(options[:source])
          when Array: options[:source]
          else []
        end
        obj_collection ||= []
        
        # iterate through all possible choices
        boxes = full_collection.collect do |item|
          n = name_for(name, '')
          id = id_for(name, item)
          checked = obj_collection.include? item
          markup = %Q{<input type="checkbox" id="#{id}" name="#{n}" value="#{item}" #{'checked' if checked} />}
          [markup, item]
        end
      
        if block_given?
          # iterate over custom markup block
          boxes.each do |markup, item|
            yield markup, item
          end
        else
          # output list of checkboxes
          out = []
          out << "<ul class='check_box_group'>\n"
          boxes.each do |markup, item|
            out << "<li>#{markup}<label for='#{id_for(name, item)}'>#{item}</label></li>\n"
          end
          out << "</ul>\n<div class='clearer'></div>\n"
          out
        end
      end
    
      private
    
      # returns the name attribute for a field by following form_for naming conventions
      def name_for(_name, _id=nil)
        n = "#{@object_name}[#{_name}]"
        n += "[#{_id}]" if _id
      end

      # returns the id attribute for a field by following form_for naming conventions
      def id_for(_name, _id=nil)
        n = "#{@object_name}_#{_name}"
        n += "_#{_id}" if _id
      end
    
    end
  
  end
end
