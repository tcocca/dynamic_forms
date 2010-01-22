class CreateDynamicForms < ActiveRecord::Migration
  def self.up
    create_table :form_field_options, :force => true do |t|
      t.column "form_field_id", :integer, :limit => 11
      t.column "label", :string
      t.column "value", :string
      t.column "position", :integer, :limit => 11
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
    
    add_index :form_field_options, ["form_field_id"], :name => "index_form_field_options_on_form_field_id"
    
    create_table :form_fields, :force => true do |t|
      t.column "name", :string
      t.column "label", :string
      t.column "form_id", :integer, :limit => 11
      t.column "type", :string
      t.column "position", :integer, :limit => 11
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "validations", :text
    end
    
    add_index :form_fields, ["form_id"], :name => "index_form_fields_on_form_id"
    
    create_table :form_submissions, :force => true do |t|
      t.column "form_id", :integer, :limit => 11
      t.column "user_id", :integer, :limit => 11
      t.column "data", :text
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
    
    add_index :form_submissions, ["form_id"], :name => "index_form_submissions_on_form_id"
    add_index :form_submissions, ["user_id"], :name => "index_form_submissions_on_user_id"
    add_index :form_submissions, ["form_id", "user_id"], :name => "index_form_submissions_on_form_id_and_user_id"
    
    create_table :forms, :force => true do |t|
      t.column "name", :string
      t.column "submit_label", :string
      t.column "email", :string
      t.column "formable_type", :string
      t.column "formable_id", :integer, :limit => 11
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "instructions", :text
      t.column "active", :boolean, :default => true
    end
    
    add_index :forms, ["formable_type", "formable_id"], :name => "index_forms_on_formable_type_and_formable_id"
  end
  
  def self.down
    drop_table :form_field_options
    drop_table :form_fields
    drop_table :form_submissions
    drop_table :forms
  end
end
