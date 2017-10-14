module Ajd2jkl
    module ContentFinder
        # Content of type main API entry @api
        class Entry < AbstractContentFinder
            def self.parser
                /^\s*\*\s+@api\s/
            end

            def check_file_name(line, _match = nil)
                return unless @name.nil?
                @name = search_api_name line
            end

            def search_api_name(line)
                m = /^\s*\*\s*@apiName\s*(?<apiname>[-\w]*)/.match(line)
                return m[:apiname] if m
                nil
            end
        end
    end
end
