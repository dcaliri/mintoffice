class Attachment < ActiveRecord::Base
  belongs_to  :user
  has_one :cardbill
  has_one :pettycash

  validates_presence_of :filepath, :on => :create, :message => "can't be blank"
  @@storage_path = "#{Rails.root}/files"

  def self.for_me(obj,order = "")
    if order.blank?
      Attachment.all(:conditions=>{:owner_table_name => obj.class.table_name,
                                    :owner_id => obj.id})
    else
      Attachment.all(:conditions=>{:owner_table_name => obj.class.table_name,
                                  :owner_id => obj.id},
                                  :order => order)
    end
  end

  def self.maximum_seq_for_me(obj)
      Attachment.maximum(:seq, :conditions=>{:owner_table_name => obj.class.table_name,
                                    :owner_id => obj.id})
  end

  def self.save_for (obj,user,param)
    attachment = Attachment.new(param)
    attachment.save_for(obj,user)
  end
  
  def save_for(obj, user)
    self.owner_table_name = obj.class.table_name
    self.owner_id = obj.id
    unless user
      user = User.find(1)
    end
    self.user = user
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
