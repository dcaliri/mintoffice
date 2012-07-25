# encoding: UTF-8

class PermissionsController < ApplicationController
  # GET /permissions
  # GET /permissions.xml
  def index
    @permissions = Permission.find(:all, :order => "name")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @permissions }
    end
  end

  def addaccount
    @permission = Permission.find(params[:id])
    @account = Account.find_by_name(params[:accountname])
    if !@account
      redirect_to @permission, alert: "등록되지 않은 사용자입니다."
    elsif @permission.employee.include?(@account.employee)
      redirect_to @permission, alert: "이미 등록된 사용자입니다."
    else
      @permission.employee << @account.employee
      redirect_to @permission, notice: "성공적으로 사용자를 등록했습니다."
    end
  end

  def removeaccount
    @employee = Employee.find(params[:employee_id])
    @permission = Permission.find(params[:id])
    @permission.employee.delete(@employee)

    redirect_to @permission
  end
  # GET /permissions/1
  # GET /permissions/1.xml
  def show
    @permission = Permission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @permission }
    end
  end

  # GET /permissions/new
  # GET /permissions/new.xml
  def new
    @permission = Permission.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @permission }
    end
  end

  # GET /permissions/1/edit
  def edit
    @permission = Permission.find(params[:id])
  end

  # POST /permissions
  # POST /permissions.xml
  def create
    @permission = Permission.new(params[:permission])

    respond_to do |format|
      if @permission.save
        flash[:notice] = 'Permission was successfully created.'
        format.html { redirect_to(@permission) }
        format.xml  { render :xml => @permission, :status => :created, :location => @permission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /permissions/1
  # PUT /permissions/1.xml
  def update
    params[:permission][:employee_ids] ||= []
    @permission = Permission.find(params[:id])

    respond_to do |format|
      if @permission.update_attributes(params[:permission])
        flash[:notice] = 'Permission was successfully updated.'
        format.html { redirect_to(@permission) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1
  # DELETE /permissions/1.xml
  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy

    respond_to do |format|
      format.html { redirect_to(permissions_url) }
      format.xml  { head :ok }
    end
  end
end
