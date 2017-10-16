require 'ajd2jkl/support'
require 'ajd2jkl/version'
require 'ajd2jkl/config'
require 'ajd2jkl/glober'
require 'ajd2jkl/file_parser'
require 'ajd2jkl/content_parser'
require 'ajd2jkl/generator'
require 'commander'

# main module
module Ajd2jkl
    @verbose = @debug = false

    def self.verbose=(v)
        @verbose = v
    end

    def self.debug?
        @debug
    end

    def self.debug=(d)
        @debug = d
    end

    # Base class wich manage all
    class Base
        def initialize(options, config)
            Ajd2jkl.verbose = options.verbose
            Ajd2jkl.debug = options.debug
            @options = options
            @config = config
            p @config
        end

        def launch(src_dir)
            Commander::UI.color('Warning! Running in dry run mode', :cyan) if @options.dry_run

            say("Parse directories : #{src_dir.join(' ')}")
            phpfiles = File.join("{#{src_dir.join(',')}}", '**', '*.php')

            gob = Glober.new(@options)
            Dir.glob(phpfiles).each do |phpfile|
                gob.inspected phpfile
                gob.gob ::Ajd2jkl::FileParser.scan phpfile
            end

            gob.info

            cp = ::Ajd2jkl::ContentParser::Parser.new(@options, @config)
            cp.parse_defines gob.defines
            cp.parse_entries gob.entries
            cp.groups

            if @options.dry_run
                Commander::UI.color('Dry run mode... exit', :cyan)
                exit(0)
            end

            ::Ajd2jkl::Generator::Base.new(@options, @config, cp).gen
        end
    end

    def self.debug(str)
        say(str) if debug?
    end

    def self.erase_line
        Commander::UI.erase_line
    end

    def self.say(str)
        Commander::UI.say(str)
    end

    def self.verbose_say(str)
        Commander::UI.color(str, :yellow) if @verbose
    end

    def self.say_error(str)
        Commander::UI.say_error(str)
    end
end

module Commander
    # Extends Commender UI Module
    module UI
        def self.erase_line
            $terminal.instance_variable_get('@output').print "\r\e[K"
        end

        # Extends Commender UI ProgressBar class
        class ProgressBar
            # override show method to don't erase progress bar when finished
            def show
                return if finished?
                erase_line
                if completed?
                    say UI.replace_tokens(@format, generate_tokens) << ' '
                    say @complete_message if @complete_message.is_a? String
                else
                    say UI.replace_tokens(@format, generate_tokens) << ' '
                end
            end
        end
    end
end
