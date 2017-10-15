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
                    Ajd2jkl.verbose_say('Analyze Common/Success... ')
                    match = @@parser.match(@raw)
                    raise "Parsing apiSuccess don't have `field` part (RE: #{@@parser}) raw: #{@raw}" unless match && match[:field]
                    @group = 'Success 200'
                    @group = match[:group] unless match[:group].nil? || match[:group].strip == ''
                    @type = match[:type] unless match[:type].nil? || match[:type].strip == ''
                    @field = match[:field]
                    md = /\=(?<defvalue>.*)$/.match @field
                    @default_value = md[:defvalue].strip unless md.nil? || md[:defvalue].strip == ''
                    @description = match[:description] unless match[:description].nil?
                    Ajd2jkl.debug("Success Line `#{@raw}`")
                    @raw = nil
                end
            end
        end
    end
end
