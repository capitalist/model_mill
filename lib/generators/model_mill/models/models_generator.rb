module ModelMill
  module Generators
    class ModelsGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      argument :namespace, :type => :string, :required => false, :default => nil
      argument :excludes, :type => :array, :required => false, :default => []

      def generate_models
        if namespace
          empty_directory("app/models/#{namespace.downcase}")
          generate_base_namespaced_model
        end
        discovered_tables.each do |table_name|
          @model_name = model_name_from_table_name table_name
          @model_file_name = model_file_name_from_table_name table_name
          template 'model.rb', "app/models/#{namespace ? namespace+'/' : ''}#{@model_file_name}.rb"
        end
        puts %Q(config.autoload_paths += %W(\#{config.root}/app/models/#{namespace.downcase})) if namespace
      end

      private
      def connection
        @conn ||= namespace ? Kernel.const_get(namespace.camelize)::Base.connection : ActiveRecord::Base.connection
      end

      def connection_info
        YAML.load(ERB.new(File.read(File.expand_path(File.join("config","database.yml")))))[namespace.downcase]
      end

      def generate_base_namespaced_model
        template 'base.rb', "app/models/#{namespace}/base.rb"
      end

      def discovered_tables
        connection.tables.sort
      end

      def model_name_from_table_name tn
        tn.singularize.camelize
      end

      def model_file_name_from_table_name tn
        tn.singularize.underscore
      end
    end
  end
end
