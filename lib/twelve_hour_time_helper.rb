module ActionView
  module Helpers
    class DateTimeSelector
      def select_hour_with_twelve_hour_time
        unless @options[:twelve_hour]
          return select_hour_without_twelve_hour_time
        end
        
        if @options[:use_hidden] || @options[:discard_hour]
          build_hidden(:hour, hour)
        else
          build_twelve_hour_options_and_select(:hour, hour, :end => 23)
        end
      end
      
      alias_method_chain :select_hour, :twelve_hour_time
      
      private
      
      def build_twelve_hour_options_and_select(type, selected, options = {})
        build_select(type, build_twelve_hour_options(selected, options))
      end
      
      def build_twelve_hour_options(selected, options = {})
        start = options.delete(:start) || 0
        stop = options.delete(:end) || 59
        step = options.delete(:step) || 1
        leading_zeros = options.delete(:leading_zeros).nil? ? true : false
        
        select_options = []
        start.step(stop, step) do |hour|
          ampm = hour <= 11 ? ' AM' : ' PM'
          ampm_hour = (hour == 0 || hour == 12) ? 12 : (hour / 12 == 1 ? hour % 12 : hour)
          display_value = "#{ampm_hour}#{ampm}"
          value = leading_zeros ? sprintf("%02d", hour) : hour
          tag_options = { :value => value }
          tag_options[:selected] = "selected" if selected == hour
          select_options << content_tag(:option, display_value, tag_options)
        end
        select_options.join("\n") + "\n"
      end
      
    end
  end
end
