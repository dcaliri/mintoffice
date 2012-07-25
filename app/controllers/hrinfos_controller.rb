class HrinfosController < ApplicationController
  before_filter :only => [:show] do |c|
    @hrinfo = Hrinfo.find(params[:id])
    c.save_attachment_id @hrinfo
  end

  before_filter :retired_hrinfo_can_access_only_admin, except: [:index, :new, :create]
  before_filter :account_only_access_my_employment, only: [:new_employment_proof]

  # GET /hrinfos
  # GET /hrinfos.xml
  def index
    params[:search_type] ||= :join
    @hrinfos = Hrinfo.search(Account.current_account, params[:search_type], params[:q])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hrinfos }
    end
  end

  def edit_required_tag
  end

  def retire
    @hrinfo = Hrinfo.find(params[:id])
  end

  def try_retired
    @hrinfo = Hrinfo.find(params[:id])
    @hrinfo.retired_on = Date.parse_by_params(params[:hrinfo], :retired_on)
  end

  def retired
    @hrinfo = Hrinfo.find(params[:id])
    @hrinfo.retired_on = params[:hrinfo][:retired_on]
    @hrinfo.retire!
    redirect_to @hrinfo, notice: I18n.t("common.messages.updated", :model => Hrinfo.model_name.human)
  end

  # GET /hrinfos/1
  # GET /hrinfos/1.xml
  def show
    @hrinfo = Hrinfo.find(params[:id])
    @related_documents = current_company.tags.related_documents(@hrinfo.account.name, Hrinfo.model_name.human)
    @required_tagnames = RequiredTag.find_all_by_modelname(Hrinfo.name).collect do |rt| rt.tag.name end
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
      format.xml  { render :xml => @hrinfo }
    end
  end

  # GET /hrinfos/new
  # GET /hrinfos/new.xml
  def new
    @hrinfo = Hrinfo.new
    # @accounts = Account.nohrinfo
    @people = Person.nohrinfo

    if @people.blank?
      flash[:notice] = t('hrinfos.new.accounts_blank')
      redirect_to :action => "index"
    else
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @hrinfo }
      end
    end
  end

  # GET /hrinfos/1/edit
  def edit
    @hrinfo = Hrinfo.find(params[:id])
  end

  # POST /hrinfos
  # POST /hrinfos.xml
  def create
    @hrinfo = Hrinfo.new(params[:hrinfo])
    @people = Person.nohrinfo

    respond_to do |format|
      if @hrinfo.save
        flash[:notice] = I18n.t("common.messages.created", :model => Hrinfo.model_name.human)
        format.html { redirect_to(@hrinfo) }
        format.xml  { render :xml => @hrinfo, :status => :created, :location => @hrinfo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hrinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hrinfos/1
  # PUT /hrinfos/1.xml
  def update
    @hrinfo = Hrinfo.find(params[:id])
    respond_to do |format|
      if @hrinfo.update_attributes(params[:hrinfo])
        flash[:notice] = I18n.t("common.messages.updated", :model => Hrinfo.model_name.human)
        format.html { redirect_to(@hrinfo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hrinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new_employment_proof
    @hrinfo = Hrinfo.find(params[:id])
    if current_company.seal.empty?
      redirect_to @hrinfo, alert: "Check company attachment."
    end
  end

  def employment_proof
    @hrinfo = Hrinfo.find(params[:id])
    send_file @hrinfo.generate_employment_proof(params[:purpose])
  end

  # DELETE /hrinfos/1
  # DELETE /hrinfos/1.xml
  def destroy
    @hrinfo = Hrinfo.find(params[:id])
    @hrinfo.destroy

    respond_to do |format|
      format.html { redirect_to(hrinfos_url) }
      format.xml  { head :ok }
    end
  end

  private
  def retired_hrinfo_can_access_only_admin
    @hrinfo = Hrinfo.find(params[:id])
    force_redirect if @hrinfo.retired? and !current_account.admin?
  end

  def account_only_access_my_employment
    @hrinfo = Hrinfo.find(params[:id])
    # force_redirect if @hrinfo.account_id != current_account.id and !current_account.admin?
    force_redirect if @hrinfo.person.account != current_account and !current_account.admin?
  end
end
