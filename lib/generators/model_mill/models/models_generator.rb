module ModelMill
  module Generators
    class ModelsGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      class_option :namespace, :type => :string, :required => false, :default => nil
      #argument :excludes, :type => :array, :required => false, :default => []

      def generate_models
        if options[:namespace]
          empty_directory("app/models/#{options[:namespace].downcase}")
          generate_base_namespaced_model
        end
        discovered_tables.each do |table_name|
          @model_name = model_name_from_table_name table_name
          @model_file_name = model_file_name_from_table_name table_name
          template 'model.rb', "app/models/#{options[:namespace] ? options[:namespace]+'/' : ''}#{@model_file_name}.rb"
        end
        puts %Q(config.autoload_paths += %W(\#{config.root}/app/models/#{options[:namespace].downcase})) if options[:namespace]
      end

      private
      def connection
        @conn ||= options[:namespace] ? Kernel.const_get(options[:namespace].camelize)::Base.connection : ActiveRecord::Base.connection
      end

      def connection_info
        YAML.load(ERB.new(File.read(File.expand_path(File.join("config","database.yml")))))[options[:namespace].downcase]
      end

      def generate_base_namespaced_model
        template 'base.rb', "app/models/#{options[:namespace]}/base.rb"
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
