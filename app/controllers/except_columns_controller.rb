class ExceptColumnsController < ApplicationController
  def create
    params[:include_column] = params[:include_column] || {}

    class_columns.each do |column|
      column = column.to_sym
      include_column = params[:include_column][column]

      if include_column
        remove_excepot_column column
      else
        add_excepot_column column
      end
    end
  end

  private
  def include_column?(column)
    !except_column?(except_key, column.to_sym)
  end
  helper_method :include_column?

  def add_excepot_column(column)
    except_column(except_key) << column unless except_column?(except_key, column.to_sym)
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