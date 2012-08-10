# encoding: UTF-8

class ExceptColumnsController < ApplicationController
  def load
    tag = params[:tag]

    except_columns.update_all(default: false)
    resource = except_columns.find_by_key(tag)
    resource.default = true
    resource.save!

    render 'reload'
  end

  def save
    tag = params[:new_tag_name]
    except_columns.update_all(default: false)
    except_columns.create!(key: tag, columns: params[:include_column], default: true)

    render 'reload'
  end

  def create
    params[:include_column] = params[:include_column] || {}

    if default_except_columns.empty?
      default_except_columns.create!(key: "default", columns: params[:include_column], default: true)
    end

    except_column = default_except_columns.first
    except_column.columns = params[:include_column]
    except_column.save!

    render 'reload'
  end

  private
  def except_columns
    current_employee.except_columns.where(model_name: class_name)
  end

  def default_except_columns
    except_columns.default
  end

  def include_column?(column)
    unless default_except_columns.empty?
      default_except_columns.first.columns[column.to_s]
    else
      true
    end
  end

  def except_column_keys
    except_columns.all.map(&:key)
  end

  def current_except_column_key
    default_except_columns.first.key rescue ""
  end
  helper_method :include_column?, :except_column_keys, :current_except_column_key

  def class_name
    params[:class_name]
  end

  def except_key
    class_name.tableize.singularize.to_sym
  end

  def class_type
    class_name.constantize
  end

  def class_columns
    class_type.default_columns
  end

  helper_method :except_key, :class_type, :class_columns
end