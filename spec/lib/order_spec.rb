require 'spec_helper'

# Re-opened. See support/models.rb
class Person
  orderable :first_name, :last_name
  orderable :fname => :first_name,
    :created => :created_at,
    :updated => :updated_at,
    :name => [:last_name, :first_name]

  orderable :job do |dir|
    joins(:job).
      order "jobs.title #{dir}"
  end

  orderable :company do |dir|
    joins(:job => :company).
      order "companies.name #{dir}"
  end
end

describe Order do

  describe '#orderable' do
    it 'handles attributes' do
      Person.order_by_first_name.to_sql.should match /"first_name" ASC/
      Person.order_by_first_name('desc').to_sql.should match /"first_name" DESC/
      Person.order_by_last_name.to_sql.should match /"last_name" ASC/
      Person.order_by_last_name('desc').to_sql.should match /"last_name" DESC/
    end
  
    it 'handles aliased attributes' do
      Person.order_by_fname.to_sql.should match /"first_name" ASC/
      Person.order_by_fname('desc').to_sql.should match /"first_name" DESC/
      Person.order_by_created.to_sql.should match /"created_at" ASC/
      Person.order_by_created('desc').to_sql.should match /"created_at" DESC/
      Person.order_by_updated.to_sql.should match /"updated_at" ASC/
      Person.order_by_updated('desc').to_sql.should match /"updated_at" DESC/
    end
  
    it 'handles multiple aliased attributes' do
      Person.order_by_name.to_sql.should match /"last_name" ASC, "first_name" ASC/
      Person.order_by_name('desc').to_sql.should match /"last_name" DESC, "first_name" DESC/
    end
  
    it 'handles custom ordering strategies' do
      Person.order_by_job.to_sql.should match /jobs.title ASC/
      Person.order_by_job('desc').to_sql.should match /jobs.title DESC/
      Person.order_by_company.to_sql.should match /companies.name ASC/
      Person.order_by_company('desc').to_sql.should match /companies.name DESC/
    end
  end
  
  describe '#order_by' do
    it 'chains multiple orderings together from comma-separated string' do
      Person.order_by('name.desc, job').to_sql.should match /"last_name" DESC, "first_name" DESC, jobs.title ASC/
    end
  end

end
