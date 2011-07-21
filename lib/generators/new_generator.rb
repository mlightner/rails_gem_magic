module RailsGem
  module Generators
    class NewGenerator < Rails::Generators::Base #:nodoc:
      
      attr_accessor :paths
      
      desc "Generate a new gem designed for use in a Rails 3+ application and optionally install it."
      namespace "rails_gem"
      generator_name "new"
      
      argument :name
      
      # Options
      method_option :rakefile, :default => true, :aliases => '-K'
      method_option :test_framework, :default => :test_unit, :aliases => '-T'
      method_option :rails_connection, :default => :engine, :aliases => '-R'
      
      method_option :bundler, :force => false, :default => true, :aliases => '-B'
      method_option :gem_path, :default => 'vendor/gems', :aliases => '-P'
      
      #Components
      method_option :rake_tasks, :force => false, :default => true, :aliases => '-R'
      method_option :generator, :force => false, :default => true, :aliases => '=G'

    end
    
    def create_skeleton
      
      # Add files
      paths.add %w{README Rakefile}
      paths.add ['lib/', 'lib/#{name}.rb']

      options[:railtie] paths.add 'lib/#{name}/railtie.rb'
      options[:engine] && paths.add 'lib/#{name}/engine.rb'
      options[:rails_rake_tasks] && paths.add 'lib/#{name}/tasks/#{name}.rake'

      # Files and dirs in the app dir
      options[:models].each do |model|
        paths.add app("models/#{model}")
      end

      options[:controllers].each do |c|
        paths.add app("controllers/#{c}")
      end
      
      options[:helpers].each do |h|
        paths.add app("helpers/#{h}")
      end
      
      options[:views].each do |v|
        paths.add app("views/#{v}")
      end


      protected

                        def run_template(path)
        template(path.template_file, path.destination_path)
                        end
      
      # The dir where the gem is going
      def gem_dir(join=nil)
        if join
          File.join(gem_dir, join)
        else
          "vendor/plugins/#{file_name}"
        end
      end
      
      def create_manifest  
      @paths ||= GemFileManifest.new do |m|
        m.rails_root        ||= GemFile.new(Rails.root rescue Dir.pwd)
        m.destination_root  ||= GemFile.new('vendor/gems')
        m.template_root     ||= GemFile.new(template_root)
      end
      
      def app(*path)
        path.flatten.uniq.collect { |f| RailsGem::Paths::GemFile.new('app/#{f}') }
      end

      def create_tasks

        def create_skeleton(&block)
          yield(self)
          # Run through all the files!
          #directory 'lib/tasks', gem_dir('lib/tasks')
          #template('templates/rake_task.tt', "#{name}/lib/#{name}.rb")
        end

        # REMOVE

        def self.source_root
          @_simple_form_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'simple_form', generator_name, 'templates'))
        end
        protected

        def format
          :html
        end

        def handler
          :erb
        end

        def filename_with_extensions(name)
          [name, format, handler].compact.join(".")
        end

        def template_filename_with_extensions(name)
          [name, format, handler, :erb].compact.join(".")
        end
      end
    end
  end


  class Newgem < Thor::Group
    include Thor::Actions

    # Define arguments and options
    argument :name
    class_option :test_framework, :default => :test_unit

    def self.source_root
      File.dirname(__FILE__)
    end

    def create_lib_file
    end

    def create_test_file
      test = options[:test_framework] == "rspec" ? :spec : :test
    end

    def copy_licence
      if yes?("Use MIT license?")
        # Make a copy of the MITLICENSE file at the source root
        copy_file "MITLICENSE", "#{name}/MITLICENSE"
      else
        say "Shame on you…", :red
      end
    end
  end
end
