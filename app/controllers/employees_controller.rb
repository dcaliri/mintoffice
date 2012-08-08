class EmployeesController < ApplicationController
  before_filter :only => [:show] do |c|
    @employee = Employee.find(params[:id])
    c.save_attachment_id @employee
  end

  before_filter :retired_employee_can_access_only_admin, except: [:index, :new, :create]
  before_filter :account_only_access_my_employment, only: [:new_employment_proof]

  def index
    params[:search_type] ||= :join
    @employees = Employee.search(current_person, params[:search_type], params[:q])
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
  end

  def new
    @employee = Employee.new
    @people = Person.no_employee

    if @people.blank?
      flash[:notice] = t('employees.new.accounts_blank')
      redirect_to :employees
    else
      render 'new'
    end
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def create
    @employee = Employee.new(params[:employee])
    @people = Person.no_employee
    @employee.save!
    redirect_to @employee, notice: I18n.t("common.messages.created", :model => Employee.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    @employee = Employee.find(params[:id])
    @employee.update_attributes!(params[:employee])
    redirect_to @employee, notice: I18n.t("common.messages.updated", :model => Employee.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'edit'
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

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    redirect_to :employees
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
