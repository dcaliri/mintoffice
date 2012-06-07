class ExceptColumnsController < ApplicationController
  def create
    params[:except] = params[:except] || {}

    class_columns.each do |column|
      column = column.to_sym
      except = params[:except][column]

      if except
        add_excepot_column column
      else
        remove_excepot_column column
      end
    end
  end

  private
  def except?(column)
    except_column?(except_key, column.to_sym)
  end
  helper_method :except?

  def add_excepot_column(column)
    except_column(except_key) << column unless except?(column)
  end

  def remove_excepot_column(column)
    except_column(except_key).delete(column)
  end

  def except_key
    class_name.tableize.singularize.to_sym
  end

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