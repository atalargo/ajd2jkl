module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiGroup parser
            # multiline: false
            # @apiGroup name
            class Group < AbstractCommon
                attr_reader :name

                def analyze
                    Ajd2jkl.verbose_say('Analyzing Common/Group... ')
                    @name = @raw.gsub(/\s/, '')
                    Ajd2jkl.verbose_say("Found appartenance of a group called `#{@name}`")
                    @raw = nil
                end
            end
        end
    end
end
