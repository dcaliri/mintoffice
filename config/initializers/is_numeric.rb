class Object
  def numeric?
    Float(self)
    true
  rescue
    false
  end
end