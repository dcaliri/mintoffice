# encoding: UTF-8

module AccessorsHelper
  def find_access_owner(accessor_params)
    class_name, id = accessor_params.split('-')
    owner = class_name.classify.constantize.find(id)
  end
end