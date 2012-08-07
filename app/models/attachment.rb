class Attachment < ActiveRecord::Base
  default_scope :order => 'seq ASC'
  belongs_to  :employee

  belongs_to :owner, :polymorphic => true
  before_save :save_employee
  def save_employee
    self.employee = Person.current_person.employee unless self.employee
  end

  validates_presence_of :filepath, :on => :create, :message => "can't be blank"
  @@storage_path = "#{Rails.root}/files"

  def self.for_me(obj,order = "")
    if order.blank?
      Attachment.all(:conditions=>{:owner_type => obj.class.to_s,
                                    :owner_id => obj.id},
                                    :order => "seq ASC")
    else
      Attachment.all(:conditions=>{:owner_type => obj.class.to_s,
                                  :owner_id => obj.id},
                                  :order => order)
    end
  end

  def self.maximum_seq_for_me(obj)
      Attachment.maximum(:seq, :conditions=>{:owner_type => obj.class.to_s,
                                    :owner_id => obj.id})
  end

  def self.save_for(obj, employee, param)
    attachment = Attachment.new(param)
    attachment.save_for(obj, employee)
  end

  def save_for(obj, employee)
    self.owner_type = obj.class.to_s
    self.owner_id = obj.id
    unless employee
      employee = Employee.find(1)
    end
    self.employee = employee.employee
    self.save
  end

  def image?
    if self.contenttype =~ /^image/
      true
    else
      false
    end
  end

  def uploaded_file=(upload_file)
    filename = base_part_of(upload_file.original_filename)
    self.original_filename = filename
    filename = Attachment.disk_filename(filename)

    # puts upload_file.content_type.chomp

    self.filepath = filename
    self.contenttype = upload_file.content_type.chomp

    if File.directory?(@@storage_path) == false
      Dir.mkdir(@@storage_path)
    end

    File.open("#{@@storage_path}/#{filename}", "wb") do |f|
      f.write(upload_file.read)
    end
  end

  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '')
  end

  def self.disk_filename(filename)
    timestamp = DateTime.now.strftime("%y%m%d%H%M%S")
    ascii = ''
    if filename =~ %r{^[a-zA-Z0-9_\.\-]*$}
      ascii = filename
    else
      ascii = Digest::MD5.hexdigest(filename)
      # keep the extension if any
      ascii << $1 if filename =~ %r{(\.[a-zA-Z0-9]+)$}
    end
    while File.exist?(File.join(@@storage_path, "#{timestamp}_#{ascii}"))
      timestamp.succ!
    end
    "#{timestamp}_#{ascii}"
  end
end
