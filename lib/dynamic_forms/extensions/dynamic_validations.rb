module DynamicForms
  module Extensions
    module DynamicValidations
      
      def validate_required
        if self.required? && answer.blank?
          add_error_to_submission(" cannot be blank.")
        end
      end
      
      def validate_number
        if self.number? && !is_number(answer) && !answer.blank?
          add_error_to_submission(" must be a number.")
        end
      end
      
      def validate_min_length
        if !self.min_length.blank? && answer.to_s.length < self.min_length
          add_error_to_submission(" must be greater than #{self.min_length} characters long.")
        end
      end
      
      def validate_max_length
        if !self.max_length.blank? && answer.to_s.length > self.max_length && !answer.blank?
          add_error_to_submission(" must be less than #{self.max_length} characters long.")
        end
      end
      
      def is_number(val)
        !(val =~ /^[+-]?[\d,]+[\.]?[\d]*$/).nil?
      end
      
      def add_error_to_submission(msg)
        puts "Adding error #{msg} on #{name}"
        submission.errors.add(name, msg)
      end
      
    end
  end
end
