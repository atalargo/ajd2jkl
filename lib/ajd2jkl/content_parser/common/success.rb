module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiSuccess parser
            # multiline: true
            # @apiSuccess [(group)] [{type}] [field=defaultValue] [description]
            class Success < AbstractParametrable
                # test regexp http://rubular.com/r/X4ArTZYSgI
                @@parser = %r{
                    ^\s*
                    (\((?<group>\w[-\w\s]*)\)\s)?\s*
                    (
                        \{(?<type>(
                                [a-zA-Z]\w*
                                (\[\])?
                                (=[-"'\w,]*)?
                                |
                                \[[A-Za-z][-\s\w]+\]\([^\s\)]*\)
                        ))\}\s
                    )?\s*
                    (?<field>
                        \[?
                            [-\w\.]+
                        \]?
                    )
                    \s*
                    (?<description>\S.*)?
                    $
                }x

                def analyze
                    Ajd2jkl.verbose_say('Analyzing Common/Success... ')
                    match = @@parser.match(@raw)
                    raise "Missing `field` part of @apiSuccess declaration (RE: #{@@parser}) raw: #{@raw}" unless match && match[:field]
                    @group = 'Success 200'
                    @group = match[:group] unless match[:group].nil? || match[:group].strip == ''
                    @type = match[:type] unless match[:type].nil? || match[:type].strip == ''
                    @field = match[:field]
                    @description = match[:description] unless match[:description].nil?
                    Ajd2jkl.debug("Success Line `#{@raw}`")
                    @raw = nil
                end
            end
        end
    end
end
