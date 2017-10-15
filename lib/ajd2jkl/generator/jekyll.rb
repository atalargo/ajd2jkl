module Ajd2jkl
    module Generator
        module Jekyll
            def self.name
                'Jekyll'
            end

            def self.description
                'Use Jekyll to generate a static documentation website'
            end

            def self.load
                require 'ajd2jkl/generator/jekyll/nav'
                require 'ajd2jkl/generator/jekyll/jerb'
            end

            def self.gen(config, options, content_parser, output_final, output)
                @@config, @@options, @@content_parser, @@output_final, @@output = config, options, content_parser, output_final, output
                jekyllize
                gen_defines
                gen_group
                images

                jekyll_build
                # clean

            end

            protected

            def self.jekyllize
                Ajd2jkl.say 'Create jekyll tree from template...'
                # `bundle exec jekyll new #{@@output} --force`
                jerb = Ajd2jkl::Generator::Jekyll::Jerb.new @@config, @@options, @@output, @@output_final
                FileUtils.mkpath @@output
                begin
                    basedir = File.dirname(__FILE__) + '/jekyll/template/'
                    Dir.entries(basedir).each do |file|
                        next if ['.', '..'].include? file
                        file = File.expand_path(basedir + file)
                        if File.directory?(file)
                            Ajd2jkl.verbose_say "Copy directory #{file}... "
                            FileUtils.cp_r file, "#{@@output}/"
                        elsif File.extname(file) == '.erb'
                            Ajd2jkl.verbose_say "Build from erb #{File.basename(file, '.erb')}... "
                            File.open("#{@@output}/#{File.basename(file, '.erb')}", 'w') { |f| f << jerb.build(file) }
                        else
                            Ajd2jkl.verbose_say "Copy file #{file}... "
                            FileUtils.cp file, "#{@@output}/"
                        end
                        Ajd2jkl.verbose_say 'OK'
                    end
                rescue => e
                    Ajd2jkl.say_error "Error during jekyll creation: #{e.message}"
                    Ajd2jkl.say_error e.backtrace.join("\n")
                    exit 1
                end

                # File.open("#{@@output}/_config.yml", 'w') { |f| f << Jekyll.get_config(@@config, @@output, @@output_final) }
                # FileUtils.mkpath "#{@@output}/_layouts/"
                # FileUtils.mkpath "#{@@output}/_includes/"
                FileUtils.mkpath "#{@@output}/_api/"
                # File.open("#{@@output}/_layouts/home.html", 'w') { |f| f << Jekyll.layout }
                # File.open("#{@@output}/_includes/nav.html", 'w') { |f| f << Jekyll.navbar_include }
                extra_docs
                gemfile
            end

            def self.gen_defines
                @@extra_defines = {}
                @@content_parser.defines.each_pair do |name, define|
                    extract_define(name, define)
                end
                @@extra_defines.each_pair do |name, define|
                    extract_define(name, define)
                end
            end

            def self.extract_define(name, define)
                front_matter = {}
                content = ''
                p define
                nodescription = false
                if define.is_a? Ajd2jkl::ContentParser::Define
                    front_matter[:name] = name
                    if define.errors?
                        define.errors.each do |error|
                            front_matter[:group] = error.group
                            content << "<tr><td>#{error.field}</td><td>#{error.description}</td></tr>\n"
                        end
                    end
                    if define.params?
                        front_matter[:params] = []
                        define.params.each do |param|
                            front_matter[:params].push 'p-' + param.field.gsub('.', '_')
                            @@extra_defines["#{name}-#{'p-' + param.field.gsub('.', '_')}"] = param
                        end
                    end
                    if define.successs?
                        front_matter[:success] = []
                        define.successs.each do |success|
                            front_matter[:success].push 's-' + success.field.gsub('.', '_')
                            @@extra_defines["#{name}-#{'s-' + success.field.gsub('.', '_')}"] = success
                        end
                    end
                    if define.headers?
                        front_matter[:success] = []
                        define.headers.each do |header|
                            front_matter[:headers].push 'h-' + header.field.gsub('.', '_')
                            @@extra_defines["#{name}-#{'h-' + header.field.gsub('.', '_')}"] = header
                        end
                    end
                    if define.success_examples?
                        front_matter[:success_examples] = []
                        define.success_examples.each do |success_example|
                            pname = success_example.title.gsub(/[^\w\s]/, '').strip.underscore
                            front_matter[:success_examples].push pname
                            @@extra_defines["#{name}-#{pname}"] = success_example
                        end
                    end
                    if define.param_examples?
                        front_matter[:param_examples] = []
                        define.param_examples.each do |param_example|
                            pname = param_example.title.gsub(/[^\w\s]/, '').strip.underscore
                            front_matter[:param_examples].push pname
                            @@extra_defines["#{name}-#{pname}"] = param_example
                        end
                    end
                    if define.error_examples?
                        front_matter[:param_examples] = []
                        define.param_examples.each do |param_example|
                            pname = param_example.title.gsub(/[^\w\s]/, '').strip.underscore
                            front_matter[:param_examples].push pname
                            @@extra_defines["#{name}-#{pname}"] = param_example
                        end
                    end
                    if define.header_examples?
                        front_matter[:param_examples] = []
                        define.param_examples.each do |param_example|
                            pname = param_example.title.gsub(/[^\w\s]/, '').strip.underscore
                            front_matter[:param_examples].push pname
                            @@extra_defines["#{name}-#{pname}"] = param_example
                        end
                    end
                else
                    case define
                    when Ajd2jkl::ContentParser::CommonContent::AbstractParametrable
                        front_matter[:group] = define.group unless define.group.nil?
                        front_matter[:field] = define.field
                        front_matter[:optional] = define.optional?
                        front_matter[:default_value] = define.default_value unless define.default_value.nil?
                        front_matter[:type] = define.type
                    when Ajd2jkl::ContentParser::CommonContent::AbstractExample
                        front_matter[:title] = define.title
                        front_matter[:type]  = define.type
                        front_matter[:right_code] = <<EOF
  ~~~ #{define.type}
  #{define.description.split("\n").map {|line| "  #{line}"}.join("\n")}
  ~~~
  {: title="#{define.title}" }
EOF
                        nodescription = true
                    end
                end
                content << define.description << (define.description.end_with?("\n") ? '' : "\n") << "\n" unless define.description.nil? || define.description.empty? || nodescription
                File.open("#{File.expand_path @@output}/_includes/#{name}.md", 'w') do |f|
                    fm = front_matter.map do |pair|
                        b = "#{pair[0]}: "
                        b += " |\n" if pair[0] == :right_code
                        b += if pair[1].is_a? Array
                                 "\n" + pair[1].map {|e| "  - #{e}"}.join("\n")
                             elsif pair[1].is_a? Hash
                                 pair[1].map {|e| "  #{e[0]}: #{e[1]}"}.join("\n")
                             else
                                 "#{pair[1]}"
                             end
                    end.join("\n")
                    f << "---\n#{fm}\n---\n\n" << content
                end
            end

            def self.gen_group
                nav_group = []
                @@content_parser.groups.each_pair do |grpname, entries|
                    nav_group.push name: grpname, burl: grpname.underscore, level: 1
                    # grpdir = @@output + '/_posts/' + Generator.underscore(grpname)
                    # FileUtils.mkpath grpdir unless Dir.exist? grpdir
                    entries.each do |ent|
                        version = if ent.versions.nil? || ent.versions.empty?
                                      ''
                                  else
                                      "?v=#{ent.versions.first.version}"
                                  end
                        nav_group.push name: ent.title, burl: "#{grpname.underscore}#{version}##{ent.name}", level: 2
                    end
                end
                FileUtils.mkpath "#{@@output}/_data/"
                File.open("#{@@output}/_data/sidebar.yml", 'w') { |f| f << Jekyll.navbar(@@config, nav_group) }
            end

            def self.jekyll_build
                Ajd2jkl.verbose_say 'Launch jekyll build...'
                IO.pipe do |read_pipe, write_pipe|
                    fork do
                        `cd #{@@output} && bundle exec jekyll build`
                    end
                    write_pipe.close
                    while line = read_pipe.gets
                        puts "Jekyll: #{line}"
                    end
                end
                Ajd2jkl.say_error 'Error during jekyll creation' && exit(1) unless $?.exitstatus.zero?
            end

            def self.gemfile
                # `echo "gem 'jekyll-theme-hydejack', '~> 6.0'" >> #{@@output}/Gemfile`
                `cd #{@@output} && bundle install`
            end

            def self.extra_docs
                return unless @@config.key?('header') || @@config.key?('footer')
                FileUtils.mkpath "#{@@output}/_documentations/"
                base_dir = File.expand_path File.dirname @@options.config
                if @@config.key?('header') && @@config['header'].key?('filename')
                    extra_doc base_dir, @@config['header']['filename'], '/index.html'
                end
                if @@config.key?('footer') && @@config['footer'].key?('filename')
                    extra_doc base_dir, @@config['footer']['filename'], File.basename(@@config['footer']['filename'], '.*')
                end
            end

            def self.images
                FileUtils.copy_entry File.expand_path(@@options.imgs), "#{@@output}/img", false, false, true if @@options.imgs
            end

            def self.clean
                FileUtils.remove_dir @@output
            end

            def self.extra_doc base_dir, filename, permalink
                File.open("#{@@output}/#{File.basename filename}", 'w') do |f|
                    f << "---\ntitle: #{File.basename filename, '.*'}\nlayout: default\npermalink: /#{permalink}.html\n---\n\n"
                    f << File.read("#{base_dir}/#{filename}")
                end
            end
        end
    end
end
