require 'active_record'
require 'order/version'

module Order
  DIRECTION_DESC = /\Adesc/i

  # Given and ordering such as "state.desc,site,name.descending", it orders the results as such
  # using the +order_by_*+ scopes.
  def order_by(ordering)
    ordering.split(',').inject(self) do |relation, orderer|
      attribute, direction = *orderer.split('.')
      relation.send "order_by_#{attribute.strip}", direction
    end
  end

  # Generates +order_by_*+ scopes used for ordering resulting records.
  # @overload orderable(*attribute_names)
  #   Generates simple ordering scopes that can accept a direction such as "desc"
  #   @param [Array] of attribute names
  # @overload orderable(attribute_map)
  #   Generates simple ordering scope using aliased mapping to one or more attributes
  #   @param [Hash] mapping ordering name to attribute(s)
  # @overload orderable(order_name, &block)
  #   Generates an ordering scope using a custom strategy specified by the given block
  # @example Custom ordering strategy
  #   orderable(:category_name){ |direction| joins(:category).order "category.name #{direction}" }
  def orderable(*attributes, &block)
    if block_given?
      raise ArgumentError.new('Cannot provide mapped naming for custom ordering strategy') if attributes.first.is_a? Hash
      order_scope attributes.first, &block
    elsif attributes.first.is_a? Hash
      attributes.first.each{ |name, attribute| order_scope name, attribute }
    else
      attributes.each{ |attribute| order_scope attribute }
    end
  end

  # Adds an +order_by_(name)+ scope. Optionally you can provide an +attribute+ to order on in case
  # the +name+ is to be an alias for the ordering. You may also provide a block that defines a
  # custom ordering strategy.
  def order_scope(name, attribute = nil, &block)
    scope "order_by_#{name}", lambda{ |direction = nil|
      if block_given?
        yield normalize_direction(direction)
      else
        if attribute.is_a? Array
          order attribute.map{ |bute| order_clause bute, direction }.join ', '
        else
          order order_clause attribute || name, direction
        end
      end
    }
  end

  # Builds an ordering clause string such as "some_table.some_attribute DESC". The direction will
  # be normalized to either "ASC" or "DESC".
  def order_clause(attribute, direction)
    "\"#{attribute || name}\" #{normalize_direction direction}"
  end

  # Converts a direction into either "ASC" or "DESC". It uses +DIRECTION_DESC+ to match the +String+.
  def normalize_direction(direction)
    (direction =~ DIRECTION_DESC) ? 'DESC' : 'ASC'
  end
end

ActiveRecord::Base.extend Order
