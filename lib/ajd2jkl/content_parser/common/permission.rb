module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiPermission parser
            # multiline: false
            # @apiPermission semantic_version
            class Permission < AbstractCommon
                attr_reader :name

                def analyze
                    Ajd2jkl.verbose_say('Analyzing Common/Permission... ')
                    @name = @raw.gsub(/\s/, '')
                    Ajd2jkl.verbose_say(" Found permission: `#{@name}`")
                    @raw = nil
                end
            end
        end
    end
end
