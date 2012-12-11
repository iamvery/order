class Person < ActiveRecord::Base
  belongs_to :job
  has_many :pet_relationships
  has_many :pets, :through => :pet_relationships
end

class Job < ActiveRecord::Base
  belongs_to :company
end

class Company < ActiveRecord::Base
end
