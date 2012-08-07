class EmployeesController < ApplicationController
  before_filter :only => [:show] do |c|
    @employee = Employee.find(params[:id])
    c.save_attachment_id @employee
  end

  before_filter :retired_employee_can_access_only_admin, except: [:index, :new, :create]
  before_filter :account_only_access_my_employment, only: [:new_employment_proof]

  # GET /employees
  # GET /employees.xml
  def index
    params[:search_type] ||= :join
    # @employees = Employee.search(Account.current_account, params[:search_type], params[:q])
    @employees = Employee.search(current_person, params[:search_type], params[:q])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @employees }
    end
  end

  def edit_required_tag
  end

  def retire
    @employee = Employee.find(params[:id])
  end

  def try_retired
    @employee = Employee.find(params[:id])
    @employee.retired_on = Date.parse_by_params(params[:employee], :retired_on)
  end

  def retired
    @employee = Employee.find(params[:id])
    @employee.retired_on = params[:employee][:retired_on]
    @employee.retire!
    redirect_to @employee, notice: I18n.t("common.messages.updated", :model => Employee.model_name.human)
  end

  # GET /employees/1
  # GET /employees/1.xml
  def show
    @employee = Employee.find(params[:id])
    @related_documents = current_company.tags.related_documents(@employee.account.name, Employee.model_name.human)
    @required_tagnames = RequiredTag.find_all_by_modelname(Employee.name).collect do |rt| rt.tag.name end
    @required_tagnames = @required_tagnames.uniq.sort

    @required_documents = {}
    @unrequired_documents = []
    @related_documents.each do |rd|
      next unless rd
      cross = rd.tags.collect(&:name) & @required_tagnames
      if cross.empty?
        @unrequired_documents << rd
      else
        cross.each do |one|
          @required_documents[one] = rd
        end
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @employee }
    end
  end

  # GET /employees/new
  # GET /employees/new.xml
  def new
    @employee = Employee.new
    @people = Person.no_employee

    if @people.blank?
      flash[:notice] = t('employees.new.accounts_blank')
      redirect_to :action => "index"
    else
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @employee }
      end
    end
  end

  # GET /employees/1/edit
  def edit
    @employee = Employee.find(params[:id])
  end

  # POST /employees
  # POST /employees.xml
  def create
    @employee = Employee.new(params[:employee])
    @people = Person.no_employee

    respond_to do |format|
      if @employee.save
        flash[:notice] = I18n.t("common.messages.created", :model => Employee.model_name.human)
        format.html { redirect_to(@employee) }
        format.xml  { render :xml => @employee, :status => :created, :location => @employee }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /employees/1
  # PUT /employees/1.xml
  def update
    @employee = Employee.find(params[:id])
    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        flash[:notice] = I18n.t("common.messages.updated", :model => Employee.model_name.human)
        format.html { redirect_to(@employee) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new_employment_proof
    @employee = Employee.find(params[:id])
    if current_company.seal.empty?
      redirect_to @employee, alert: "Check company attachment."
    end
  end

  def employment_proof
    @employee = Employee.find(params[:id])
    send_file @employee.generate_employment_proof(params[:purpose])
  end

  # DELETE /employees/1
  # DELETE /employees/1.xml
  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to(employees_url) }
      format.xml  { head :ok }
    end
  end

  private
  def retired_employee_can_access_only_admin
    @employee = Employee.find(params[:id])
    force_redirect if @employee.retired? and !current_person.admin?
  end

  def account_only_access_my_employment
    @employee = Employee.find(params[:id])
    force_redirect if @employee.person != current_person and !current_person.admin?
  end
end
