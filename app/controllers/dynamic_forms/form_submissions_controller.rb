class DynamicForms::FormSubmissionsController < ApplicationController
  unloadable
  
  before_filter :load_form
  
  def index
    @form_submissions = @form.form_submissions
  end
  
  def show
    @form_submission = @form.form_submissions.find(params[:id])
  end
  
  def new
    @form_submission = @form.form_submissions.build
  end
  
  def create
    @form_submission = @form.form_submissions.submit(params[:form_submission])
    if !@form_submission.new_record?
      flash[:notice] = "Thank you for filling out this form!"
      redirect_to form_form_submission_path(@form, @form_submission)
    else
      render :action => 'new'
    end
  end
  
  private
  
  def load_form
    @form = ::Form.find(params[:form_id])
  end
end
