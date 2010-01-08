# The FormField class is an abstract model of a field that is in a form. It holds information about
# naming, labelling, validation etc. for that field. It is subclassed for each kind of form field.
class FormField < ActiveRecord::Base

  belongs_to :form
  has_many :form_field_options, :order => 'position ASC, label ASC'
  
  validates_presence_of :name
    
  before_validation :assign_name
  
  TYPES = %w{text_field text_area select check_box check_box_group}
  VALIDATION_TYPES = %w{required number max_length min_length}
  
  def validate_submission(submission)
    val = submission.send(name)
    VALIDATION_TYPES.each do |validation|
      if msg = error_for_value(val, validation)
        puts "Adding error #{msg} on #{name}"
        submission.errors.add(name, msg)
      end
    end
  end
  
  def kind
    self.class.to_s.split("::").last.underscore
  end
  
  # overridden by has_many_responses
  def has_many_responses?
    false
  end
  
  # indicates that the value of this field is an array of responses
  def self.has_many_responses
    define_method("has_many_responses?") { true }
  end
  
  # overridden by acts_as_selector
  def is_selector?
    false
  end
  
  # indicates there is a static set that can be used in a select, check_box_group, etc
  def self.acts_as_selector
    define_method("is_selector?") { true }
  end
  
  # for now, option labels and values will be the same
  # Displays a comma delimited string of form_field_options for editing
  def options_string
    self.form_field_options.map {|ffo| ffo.label}.join(', ')
  end
  
  # for now, option labels and values will be the same
  # This is a virtual attribute for setting form_field_options with a comma delimited string
  def options_string=(str)
    self.form_field_options.delete_all
    arr = str.split(',')
    arr.each_with_index {|l, i| self.form_field_options.build(:label => l.strip, :value => l.strip, :position => i)}
  end
  
  def name
    self[:name]
  end
  
  def name_with_default
    orig = name_without_default
    if orig.blank?
      assign_name
      name_without_default
    else
      orig
    end
  end
  alias_method_chain :name, :default
  
  #overwritten by self.allow_validation_of
  def allow_validation_of?(sym)
    false
  end
  
  def self.allow_validation_of(*syms)
    define_method 'allow_validation_of?' do |sym|
      syms.include? sym
    end
  end
  
  private
  
  def assign_name
    self.name = "field_" + Digest::SHA1.hexdigest(self.label + Time.now.to_s).first(20)
  end
  
  def error_for_value(val, validation)
    case validation
      when "required" 
        " cannot be blank." if self.required? && val.blank?
      when "max_length"
        " must be less than #{self.max_length} characters long." if !self.max_length.blank? && val.to_s.length > self.max_length && !val.blank?
      when "min_length"
        " must be greater than #{self.min_length} characters long." if !self.min_length.blank? && val.to_s.length < self.min_length
      when "number"
        " must be a number." if self.number? && !is_number(val) && !val.blank?
    end
  end
  
  def is_number(val)
    !(val =~ /^[+-]?[\d,]+[\.]?[\d]*$/).nil?
  end
  
end
