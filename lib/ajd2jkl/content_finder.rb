module Ajd2jkl
    module ContentFinder
        def self.recolt_parser
            {
                define: { parser: Define.parser, klass: Define },
                entry: { parser: Entry.parser, klass: Entry },
                ignore: { parser: /^\s*\*\s+@apiIgnore\s*(?<hint>.*)?/, klass: nil},
                end: { parser: /^\s*\*\//, klass: nil}
            }
        end

        class AbstractContentFinder
            attr_reader :name, :content, :from_file, :from_line

            def initialize(file, line)
                @from_file, @from_line = file, line
                @content = []
                @name = nil
            end

            def name=(n)
                @name = n
            end

            def add_content(ncontent, match = nil)
                @content.push ncontent
                check_file_name ncontent, match unless @name
            end

            def clear_content
                @content = nil
            end

            def check_file_name(ncontent, match = nil)
                throw ::Error.new 'The class method `check_file_name` should be overridden'
            end

            def self.parser
                throw ::Error.new 'The class method `get_parser` should be overridden'
            end
        end
    end
end
require 'ajd2jkl/content_finder/define'
require 'ajd2jkl/content_finder/entry'
