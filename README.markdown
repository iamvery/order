# Order [![Build Status](https://travis-ci.org/iamvery/order.png?branch=master)](https://travis-ci.org/iamvery/order)
Convenient ActiveRecord ordering.
https://github.com/iamvery/order

## Introduction

Order provides a convenient DSL for adding ordering scopes to ActiveRecord
models. Additionally it provides an `order_by` method that allows you to 
get records by multiple orderings using a simple syntax. This is great for
APIs. Take this model for example:

## Getting Started

Add `order` to your `Gemfile`:

    gem 'order', '~> 0.1'

Bundle it up:

    # From the command line
    bundle install

## Usage

Add some ordering to your models:

    Person < ActiveRecord::Base
      belongs_to :job
      attr_accessible :first_name, :last_name

      orderable :first_name, :last_name
      orderable :name => [:last_name, :first_name]
      orderable :job_title do |direction|
        joins(:job).order "jobs.title #{direction}"
      end
    end

Now you can retrieve people in order!

    Person.order_by_first_name
    => SELECT "people".* FROM "people" ORDER BY "first_name" ASC

    Person.order_by_first_name(:desc)
    => SELECT "people".* FROM "people" ORDER BY "first_name" DESC

    Person.order_by_name
    => SELECT "people".* FROM "people" ORDER BY "last_name" ASC, "first_name" ASC

    Person.order_by_job_title
    => SELECT "people".* FROM "people" INNER JOIN "jobs" ON "jobs"."id" = "person"."job_id" ORDER BY jobs.title ASC

You can also get at ordering using the `order_by` method:

    Person.order_by 'name.desc, job_title'
    => SELECT "people".* FROM "people" INNER JOIN "jobs" ON "jobs"."id" = "person"."job_id" ORDER BY "last_name" DESC, "first_name" DESC, jobs.title ASC

This is super helpful when developing APIs that need to provide ordered
results. Consider the following:

    PeopleController < ApplicationController
      respond_to :html
      def index
        @requests = Person.order_by params[:order]
        respond_with @requests
      end
    end

A simple request to "/people?order=name.desc,job_title" will give you ordered results! :)

## Contributing

This is a baby library! _Cute_? Absolutely. But also hoping to grow up into a
big, useful tool to be take advantage of! (Something about that really
doesn't sound right)

* Use it.
* Pick it apart.
* Let me know what you think.
* Tell others.

Please add issues and send pull requests!

## Copyright

Copyright © 2012 Jay Hayes
