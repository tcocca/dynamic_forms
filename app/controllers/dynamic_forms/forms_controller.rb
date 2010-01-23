class DynamicForms::FormsController < ApplicationController
  unloadable
  
  def index
    @forms = ::Form.paginate(:all, :page => params[:page] || 1)
    render :template => "forms/index"
  end
  
  # the Forms#show action actually renders FormSubmissions#new for displaying the form
  def show
    @form = ::Form.find(params[:id])
    @form_submission = @form.form_submissions.build
    render :template => 'form_submissions/new'
  end
  
  def new
    @form = ::Form.new(:submit_label => 'Submit')
    render :template => "forms/new"
  end
  
  def edit
    @form = ::Form.find(params[:id])
    render :template => "forms/edit"
  end
  
  def create
    # check to see if preview should be rendered rather than saving changes
    preview_new and return if params[:commit].to_s.downcase == 'preview'
    
    @form = ::Form.new(params[:form])
    if @form.save
      flash[:notice] = %Q{The form "#{@form.name}" was successfully create.}
      redirect_to form_path(@form)
    else
      render :action => 'new', :template => "forms/new"
    end
  end
  
  def update
    # check to see if preview should be rendered rather than saving changes
    preview_edit and return if params[:commit].to_s.downcase == 'preview'

    @form = ::Form.find(params[:id])
    
    if @form.update_attributes(params[:form])
      flash[:notice] = "The form #{@form.name} was successfully updated."
      redirect_to form_path(@form)
    else
      render :action => 'edit', :template => "forms/edit"
    end
  end
  
  def destroy
    form = ::Form.find(params[:id])
    form.destroy
    flash[:notice] = "The form #{form.name} was deleted."
    redirect_to forms_path
  end
  
  private
  
  def preview_new
    @form = ::Form.new(params[:form])
    if @form.valid?
      @form_submission = @form.form_submissions.build
      @form_submission.form = @form # Believe it or not, this is necessary
    end
    render :action => 'new', :template => "forms/new"
  end
  
  def preview_edit
    @form = ::Form.new(params[:form])
    @form.id = params[:id]
    if @form.valid?
      @form_submission = @form.form_submissions.build
      @form_submission.form = @form # Believe it or not, this is necessary
    end
    render :action => 'edit', :template => "forms/edit"
  end
  
end
