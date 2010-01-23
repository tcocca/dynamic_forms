# Helpers for displaying FormSubmission data
module DynamicForms
  module FormSubmissionsHelper
    
    def self.included(base)
      ActionView::Helpers::FormBuilder.send :include, FormBuilderMethods
    end
    
    # mixes in FormBuilder#form_submission_error_messages method
    module FormBuilderMethods
      # Use instead of FormBuilder#error_messages when working with FormSubmissions,
      # works the same but uses the attribute's label rather than its name
      # (the name is jibberish)
      def form_submission_error_messages
        raise unless @object.is_a?(FormSubmission)
        msg = error_messages
        @object.form.form_fields.each {|field| msg.gsub!(/#{Regexp.escape(field.name).humanize}/, "\"#{field.label}\"")}
        msg
      end
    end
    
    # Instantiates a FormSubmissionFieldDisplay object
    # 
    # To use the default formatting markup, just pass the field name and value:
    # 
    #   <% @form_submission.each_field do |field, value| %>
    #       <%= format_submission_field(field, value) %>
    #   <% end %>
    # 
    # If you want to use your own custom markup instead, pass a block with label 
    # and value block params:
    # 
    #   <dl>
    #     <% @form_submission.each_field do |field, value| %>
    #       <% format_submission_field(field, value) do |label, val| %>
    #         <dt><%= label %></dt>
    #         <dd><%= val %></dd>
    #       <% end %>
    #     <% end %>  
    #   </dl>
    # 
    def format_submission_field(field, value, &block)
      FormSubmissionFieldDisplay.new(self, field, value, &block)
    end
    
    # Helper class that formats the value of a FormSubmission's field
    class FormSubmissionFieldDisplay
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      
      # String output representing a blank response
      NO_RESPONSE = "(no response)"
      
      # String output for 'true'
      TRUE_VALUE = "Yes"
      
      # String output for 'false'
      FALSE_VALUE = "No"
      
      # Do not instantiate directly, use the #formate_submission_field method instead
      def initialize(template, field, value, &block)
        @field = field
        @value = value
        @template = template
        if @block = block
          to_s # render when block passed in <% ... %> tags
        end
      end
      
      # used to output the generated markup
      def to_s
        label = @field.label
        val = @field.is_a?(::FormField::FileField) ? formatted_value : @template.send(:h, formatted_value)
        if @block
          @template.concat(@template.capture(label, val, &@block), @block.binding)
        else
          <<-EOF
            <div class="form_submission_field_display">
              <strong class="label">#{label}:</strong>
              <span class="response">#{val}</span>
            </div>
          EOF
        end
      end
      
      private
      
      # formats value as a list, value or boolean based on the type of form field
      def formatted_value
        if @field.has_many_responses?
          # ensure value is an array
          val = @value || [NO_RESPONSE]
          val = [val] unless val.respond_to?('join')
          val = val.join(", ")
          value_with_blank_notice(val)
        elsif @field.is_a? ::FormField::FileField
          value_with_download_link(@value)
        elsif @field.is_a? ::FormField::CheckBox
          @value == '1' ? TRUE_VALUE : FALSE_VALUE
        else
          value_with_blank_notice(@value)
        end
      end
      
      def value_with_blank_notice(val = nil)
        val.blank? ? NO_RESPONSE : val
      end
      
      def value_with_download_link(val = nil)
        val.blank? ? NO_RESPONSE : "#{format_filename(val)} #{link_to('Download', val, {:target => '_blank'})}"
      end
      
      def format_filename(filename)
        filename.split('/').last.to_s
      end
    end
    
  end
end
