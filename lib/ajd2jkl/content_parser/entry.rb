module Ajd2jkl
    module ContentParser
        # parser for Entry annotation (@api)
        class Entry < AbstractParser
            attr_reader :path, :method

            protected

            API_PARSER = %r{
                ^
                    \s*\*\s*@api\s
                    \{(?<method>((
                        get|GET|put|PUT|post|POST|
                        delete|DELETE|patch|PATCH|
                        head|HEAD|options|OPTIONS|
                        trace|TRACE|connect|CONNECT
                    )(\s?/\s?(
                        get|GET|put|PUT|post|POST|
                        delete|DELETE|patch|PATCH|
                        head|HEAD|options|OPTIONS|
                        trace|TRACE|connect|CONNECT
                    ))*))\}\s+
                    (?<path>\S*)\s*
                    (?<title>\S.*)?
                $
            }x

            def parse_first_line(line)
                # first line it's the @api {method} path [title]

                match = API_PARSER.match line
                raise "Missing `path` part of @api declaration (RE: #{API_PARSER}) raw: #{@raw}" unless match && match[:path]
                raise "Missing `method` part of @api declaration (RE: #{API_PARSER}) raw: #{@raw}" unless match && match[:method]
                @path = match[:path]
                @method = match[:method]
                @title = match[:title]
                Ajd2jkl.verbose_say "Entry has path #{@path} with method #{@method}"
            end
        end
    end
end
