module DynamicForms
  module Extensions
    module DynamicValidations
      
      def validate_required
        if self.required? && answer.blank?
          add_error_to_submission(" cannot be blank.")
        end
      end
      
      def validate_number
        if self.number? && !is_number? && !answer.blank?
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
      
      def validate_zip_code
        if self.zip_code? && !is_zip_code? && !answer.blank?
          add_error_to_submission(" must be a valid zip code.")
        end
      end
      
      def validate_email
        if self.email? && !is_email? && !answer.blank?
          add_error_to_submission(" must be a valid email address.")
        end
      end
      
      def validate_phone_number
        if self.phone_number? && !is_phone_number? && !answer.blank?
          add_error_to_submission(" must be a valid phone number.")
        end
      end
      
      def validate_url
        if self.url? && !is_url? && !answer.blank?
          add_error_to_submission(" must be a valid url.")
        end
      end
      
      def validate_confirmed
        if self.confirmed? && !is_confirmed?
          add_error_to_submission(" must be selected.")
        end
      end
      
      private
      
      def is_number?
        !(answer =~ /^[+-]?[\d,]+[\.]?[\d]*$/).nil?
      end
      
      def is_zip_code?
        !(answer =~ /^\d{5}-\d{4}?|^\d{5}$/).nil?
      end
      
      def is_email?
        !(answer =~ /#{RFC822::EmailAddress}/).nil?
      end
      
      def is_phone_number?
        !(answer =~ /(\()?\d{3}((\) )|\ |-|\.)?\d{3}(\ |-|\.)?\d{4}/).nil?
      end
      
      def is_url?
        self.answer = "http://#{answer}" unless (answer.include?('http://') || answer.include?('https://'))
        !(answer =~ /(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix).nil?
      end
      
      def is_confirmed?
        !answer.blank? && answer == "1"
      end
      
      def add_error_to_submission(msg)
        puts "Adding error #{msg} on #{name}"
        submission.errors.add(name, msg)
      end
      
    end
  end
end


#
# RFC822 Email Address Regex
# --------------------------
# 
# Originally written by Cal Henderson
# c.f. http://iamcal.com/publish/articles/php/parsing_email/
#
# Translated to Ruby by Tim Fletcher, with changes suggested by Dan Kubb.
#
# Licensed under a Creative Commons Attribution-ShareAlike 2.5 License
# http://creativecommons.org/licenses/by-sa/2.5/
# 
module RFC822
  EmailAddress = begin
    qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
    dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
    atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-' +
      '\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
    quoted_pair = '\\x5c[\\x00-\\x7f]'
    domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
    quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
    domain_ref = atom
    sub_domain = "(?:#{domain_ref}|#{domain_literal})"
    word = "(?:#{atom}|#{quoted_string})"
    domain = "#{sub_domain}(?:\\x2e#{sub_domain})*"
    local_part = "#{word}(?:\\x2e#{word})*"
    addr_spec = "#{local_part}\\x40#{domain}"
    pattern = /\A#{addr_spec}\z/
  end
end
