# encoding: UTF-8
class ExceptColumnsController < ApplicationController
  def create
    params[:include_column] = params[:include_column] || {}

    tag = params[:new_tag_name]
    if tag.present?
      collection = current_user.except_columns.where(model_name: class_name)

      collection.update_all(default: false)
      collection.create!(key: tag, columns: params[:include_column], default: true)

      return
    end

    tag = params[:tag]
    if params[:tag_selected] == 'true'
      collection = current_user.except_columns.where(model_name: class_name)

      collection.update_all(default: false)
      resource = collection.find_by_key(tag)
      resource.default = true
      resource.save!

      return
    end

    except_columns = current_user.except_columns.where(model_name: class_name).default
    if except_columns.empty?
      except_columns.create!(key: "default", columns: params[:include_column], default: true)
    end

    except_column = except_columns.first
    except_column.columns = params[:include_column]
    except_column.save!
  end

  private

  def include_column?(column)
    except_columns = current_user.except_columns.where(model_name: class_name).default
    unless except_columns.empty?
      except_columns.first.columns[column.to_s]
    else
      true
    end
  end

  def except_column_keys
    except_columns = current_user.except_columns.where(model_name: class_name)
    except_columns.all.map(&:key)
  end

  def current_except_column_key
    except_columns = current_user.except_columns.where(model_name: class_name).default
    except_columns.first.key rescue ""
  end
  helper_method :include_column?, :except_column_keys, :current_except_column_key

  def except_key
    class_name.tableize.singularize.to_sym
  end
  helper_method :except_key

  def class_name
    params[:class_name]
  end

  def class_type
    class_name.constantize
  end

  def class_columns
    class_type.default_columns
  end

  helper_method :class_type, :class_columns
end