# Grabbed from here: https://github.com/kristianmandrup/canable/blob/master/spec/generator_spec_helper.rb

require 'rubygems'
require 'test/unit'
require 'rails/all'
require 'rails/generators'
require 'rails/generators/test_case'

require 'rails_spec_helper'

# Call configure to load the settings from
# Rails.application.config.generators to Rails::Generators

Rails::Generators.configure!

# require the generators
def require_generators generator_list
  generator_list.each do |name, generators|
    generators.each do |generator_name|
      require File.join('generators', name.to_s, generator_name.to_s, "#{generator_name}_generator")
    end
  end
end

module RSpec
  module Generators
    class TestCase < ::Rails::Generators::TestCase
      setup :prepare_destination
      # setup :copy_routes
      destination File.join(::Rails.root)

      def initialize(test_method_name)
        @method_name = test_method_name
        @test_passed = true
        @interrupted = false
        #copy_routes
      end

      protected

      def copy_routes
        routes_file = File.join(File.dirname(__FILE__), 'fixtures', 'routes.rb')
        # puts "routes_file: #{routes_file}"
        routes = File.expand_path(routes_file)
        destination = File.join(::Rails.root, "config")
        FileUtils.mkdir_p(destination)
        FileUtils.cp File.expand_path(routes), destination
      end

    end
  end
end


module GeneratorSpec
  class << self
    attr_accessor :generator, :test_method_name

    def clean!
      if generator
        generator.class.generator_class = nil
      end
      @generator = nil
    end

    def get_generator test_method_name=nil
      @generator ||= RSpec::Generators::TestCase.new(test_method_name + '_spec')
    end

    def run_generator *args, &block
      generator.run_generator *args
      if block
        block.arity < 1 ? generator.instance_eval(&block) : block.call(generator, self)
      end
    end

    def check(&block)
      if block
        block.arity < 1 ? self.instance_eval(&block) : block.call(self)
      end
    end

    def with(generator, &block)
      if block
        block.arity < 1 ? generator.instance_eval(&block) : block.call(generator) #, self, generator.class)
      end
    end

    def with_generator &block
      with(get_generator, &block)
    end

    def setup_generator test_method_name=nil, &block
      clean! if test_method_name
      generator = get_generator(test_method_name)
      if block
        block.arity < 1 ? generator.class.instance_eval(&block) : block.call(generator.class)
      end
    end


    def check_methods methods
      methods.each do |method_name|
        content.should_match /def #{method_name}_by?(user)/
      end
    end
    alias_method :methods, :check_methods

    def check_matchings matchings
      matchings.each do |matching|
        content.should_match /#{Regexp.escape(matching)}/
      end
    end
    alias_method :matchings, :check_matchings

    def check_file file
      generator.should generate_file file
    end
    alias_method :file, :check_file

    def check_class_methods methods
      methods.each do |method_name|
        content.should_match /def self.#{method_name}_by?(user)/
      end
    end
    alias_method :class_methods, :check_class_methods

    def check_view(folder, file_name, strings)
      generator.should generate_file("app/views/#{folder}/#{filename}") do |file_content|
        strings.each do |str|
          content.should_match /#{Regexp.escape(str)}/
        end
      end
    end
    alias_method :view, :check_view

    def check_model(name, clazz, options = {})
      generator.should generate_file("app/models/#{name.underscore}.rb") do |file_content|
        file_content.should have_class user.camelize do |content|
          check_matchings options[:matchings]
          check_methods(options[:methods])
          check_class_methods(options[:class_methods])
        end
      end
    end
    alias_method :model, :check_model
  end # class self
end

