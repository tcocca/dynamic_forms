module DynamicForms
  module Relationships
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def is_form_creator
        has_many :created_forms, :as => :creator, :class_name => 'Form', :dependent => :nullify
      end
      
      def is_form_submitter
        has_many :form_submissions, :as => :submitter, :dependent => :nullify
      end
    end
    
  end
end
