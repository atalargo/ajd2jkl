module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiPrivate parser
            # multiline: false
            # @apiPrivate semantic_version
            class Private < AbstractCommon
                attr_reader :version

                def analyze
                    Ajd2jkl.verbose_say('Analyzing Common/Private... This could generate private API documentation ')
                    @raw = nil
                end
            end
        end
    end
end
