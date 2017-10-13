
require 'fileutils'
# require 'ajd2jkl/generator/jekyll'

module Ajd2jkl
    module Generator
        def self.list_generators
            say "Available generators are:\n\n"
            list_gen_mod.each do |gen|
                say "- #{gen[:name]}: #{gen[:description]}, option: #{gen[:option]}"
            end
            say "\nDefault generator is Jekyll\n"
        end

        protected

        def self.list_gen_mod
            Dir.entries(File.dirname(__FILE__) + '/generator/').grep(/.*\.rb$/).map do |entry|
                entry = entry.sub(/\.rb$/, '')
                require "ajd2jkl/generator/#{entry}"
                module_name = entry.split('_').collect(&:capitalize).join
                m = Object::const_get("Ajd2jkl::Generator::#{module_name}")
                {option: entry, name: m.name, description: m.description, module: module_name}
            end
        end

        public

        # class Generator::Base
        class Base
            def initialize(options, config, content_parser)
                @options = options
                @config = config
                @content_parser = content_parser

                @generator_def = Generator.list_gen_mod.select { |s| s[:option] == options.generator }.first
                Ajd2jkl.say_error("Generator '#{options.generator}' not found") && exit(1) if @generator_def.nil?
                say "selected generator: #{@generator_def[:name]}"
                @generator = Object::const_get("Ajd2jkl::Generator::#{@generator_def[:module]}")
                @generator.load

                output_dir
            end

            def output_dir
                @output_final = File.expand_path(@options.output || './docs')
                FileUtils.mkpath @output_final unless Dir.exist? @output_final
                @output = "#{File.expand_path File.dirname @output_final}/.tmp_#{File.basename(@output_final).tr('.', '_')}"
                FileUtils.mkpath @output unless Dir.exist? @output
                Ajd2jkl.say "Generate documentation in #{@output_final}"
            end

            def gen
                @generator.gen(@config, @content_parser, @output_final, @output)
            end
        end

        def self.underscore(camel_cased_word)
            return camel_cased_word unless /[-A-Z ]|::/.match(camel_cased_word)
            word = camel_cased_word.to_s.gsub('::'.freeze, '/'.freeze)
            word.gsub!(/(?:(?<=([A-Za-z\d]))|\b)()(?=\b|[^a-z])/) { "#{$1 && '_'.freeze }#{$2.downcase}" }
            word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
            word.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
            word.tr!('-'.freeze, '_'.freeze)
            word.downcase!
            word
        end
    end
end
