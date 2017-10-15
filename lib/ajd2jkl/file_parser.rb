require 'ajd2jkl/content_finder'
require 'commander/user_interaction'

module Ajd2jkl
    # Base PhpFileParser
    module FileParser
        @current_is      = nil
        @current         = nil
        @current_file    = nil

        @parsers = Ajd2jkl::ContentFinder.recolt_parser

        def self.scan(file)
            @return = { define: [], entry: [] }
            begin
                @f = File.open((@current_file = File.expand_path(file)))
                @f.readlines.each_with_index do |line, idx|
                    parse_line(line, idx + 1)
                end
            rescue => e
                Ajd2jkl.say_error("Error during parsing #{@current_file} : #{e.message}")
                print e.backtrace.join("\n") + "\n" if @verbose
                @return = false
            ensure
                @f.close
            end
            @return
        end

        def self.parse_line(line, idx)
            case line
            when @parsers[:ignore][:parser]
                set_current idx, :ignore, $~, line
            when @parsers[:entry][:parser]
                set_current idx, :entry, $~, line
            when @parsers[:define][:parser]
                set_current idx, :define, $~, line
            when @parsers[:end][:parser]
                inject_current
            else
                @current.add_content line unless @current.nil?
            end
            nil
        end

        def self.set_current(linenumber, type, match, line)
            if type == :ignore
                @current_is = :ignore
                Ajd2jkl.verbose_say(
                    "Api Ignore Found in file #{@current_file} line ##{linenumber}" +
                    (match && match[:hint] ? " Reason is: #{match[:hint]}" : '')
                )
            else
                inject_current unless @current.nil?
                unless @current_is == :ignore
                    @current_is = type
                    @current = @parsers[@current_is][:klass].new @current_file, linenumber unless @current
                    @current.add_content line, match
                end
            end
        end

        def self.inject_current
            @return[@current_is].push @current unless @current.nil?
            @current = nil
            @current_is = nil
            nil
        end
    end
end
