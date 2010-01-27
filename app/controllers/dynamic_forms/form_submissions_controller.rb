class DynamicForms::FormSubmissionsController < ApplicationController
  unloadable
  
  before_filter :load_form
  
  def index
    @form_submissions = @form.form_submissions
    render :template => "form_submissions/index"
  end
  
  def show
    @form_submission = @form.form_submissions.find(params[:id])
    @submitted = (params[:submitted] ? true : false)
    render :template => "form_submissions/show"
  end
  
  def new
    @form_submission = @form.form_submissions.build
    render :template => "form_submissions/new"
  end
  
  def create
    @form_submission = @form.form_submissions.submit(params[:form_submission])
    if !@form_submission.new_record?
      flash[:notice] = "Thank you for filling out this form!"
      if @form.email_submissions? && !@form.email.blank?
        ::DynamicFormsMailer.deliver_form_submission(@form_submission)
      end
      redirect_to form_form_submission_path(@form, @form_submission, :submitted => true)
    else
      render :action => 'new', :template => "form_submissions/new"
    end
  end
  
  private
  
  def load_form
    @form = ::Form.find(params[:form_id])
  end
  
end
