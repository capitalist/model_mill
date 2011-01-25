require 'rake'
require 'ap'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'generators/model_mill/models/models_generator'

RSpec::Matchers.define :generate_file do |expected|
  match do |actual|
    expected_path = File.expand_path(expected, Rails.application.root)
    File.exists?(expected_path)
  end

  failure_message_for_should do |actual|
    "expected a file at #{expected}"
  end

  failure_message_for_should_not do |actual|
    "expected there to be no file at #{expected}"
  end

  description do
    "generate the file at #{expected}"
  end
end

def file_contents path
  File.read(File.expand_path(path, ::Rails.root))
end

describe 'models_generator' do
  context 'with namespace option' do
    before :each do
      GeneratorSpec.setup_generator 'model_generator' do
        tests ModelMill::Generators::ModelsGenerator
      end
      @namespace = 'legacy'
      @tables = %w(users widgets)
    end

    after :each do
      FileUtils.rm_r File.expand_path("app/models/#{@namespace}", ::Rails.root)
    end

    it "generates a base model for the namespace" do
      GeneratorSpec.with_generator do |g|
        g.run_generator @namespace
        g.should generate_file("app/models/#{@namespace}")
        g.should generate_file("app/models/#{@namespace}/base.rb")
        file_contents("app/models/#{@namespace}/base.rb").should match(/class #{@namespace.camelize}::Base < ActiveRecord::Base/)
      end
    end

    it "generates a model for each table" do
      GeneratorSpec.with_generator do |g|
        g.run_generator @namespace
        @tables.each do |tn|
          g.should generate_file("app/models/#{@namespace}/#{tn.singularize.underscore}.rb")
        end
      end
    end
  end

  context 'without namespace option' do
    before :each do
      GeneratorSpec.setup_generator 'model_generator' do
        tests ModelMill::Generators::ModelsGenerator
      end
      @tables = %w(users widgets)
    end

    after :each do
      @tables.each do |tn|
        FileUtils.rm_r File.expand_path("app/models/#{tn.singularize.underscore}.rb", ::Rails.root)
      end
    end

    it "generates a model for each table" do
      GeneratorSpec.with_generator do |g|
        g.run_generator
        @tables.each do |tn|
          g.should generate_file("app/models/#{tn.singularize.underscore}.rb")
          file_contents("app/models/#{tn.singularize.underscore}.rb").should match(/class #{tn.singularize.camelize} < ActiveRecord::Base/)
        end
      end
    end
  end
end

