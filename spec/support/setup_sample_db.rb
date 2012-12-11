require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false

  ActiveRecord::Schema.define do
    create_table :people, :force => true do |t|
      t.string     :first_name
      t.string     :last_name
      t.references :job
      t.timestamps
    end

    create_table :jobs, :force => true do |t|
      t.string     :title
      t.references :company
    end

    create_table :companies, :force => true do |t|
      t.string :name
    end
  end
end
