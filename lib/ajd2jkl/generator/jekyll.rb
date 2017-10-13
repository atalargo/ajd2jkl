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
                require 'ajd2jkl/generator/jekyll/config'
                require 'ajd2jkl/generator/jekyll/layout'
                require 'ajd2jkl/generator/jekyll/nav'
            end

            def self.gen(config, content_parser, output_final, output)
                @config, @content_parser, @output_final, @output = config, output_final, output
                jekyllize
                gen_defines
                gen_group
                images

                jekyll_build
                # clean

            end

            protected

            def self.jekyllize
                Ajd2jkl.verbose_say 'Launch jekyll create...'
                `bundle exec jekyll new #{@output} --force`
                Ajd2jkl.say_error 'Error during jekyll creation' && exit(1) unless $?.exitstatus.zero?
                File.open("#{@output}/_config.yml", 'w') { |f| f << Jekyll.get_config(@config, @output, @output_final) }
                FileUtils.mkpath "#{@output}/_layouts/"
                FileUtils.mkpath "#{@output}/_includes/"
                FileUtils.mkpath "#{@output}/_api/"
                File.open("#{@output}/_layouts/home.html", 'w') { |f| f << Jekyll.layout }
                File.open("#{@output}/_includes/nav.html", 'w') { |f| f << Jekyll.navbar_include }
                extra_docs
                gemfile
            end

            def self.gen_defines
            end

            def self.gen_group
                nav_group = []
                @content_parser.groups.each_pair do |grpname, entries|
                    p "#{grpname} => #{Generator.underscore(grpname)}"
                    nav_group.push name: grpname, burl: Generator.underscore(grpname), level: 1
                    grpdir = @output + '/_posts/' + Generator.underscore(grpname)
                    FileUtils.mkpath grpdir unless Dir.exist? grpdir
                    entries.each do |ent|
                        nav_group.push name: ent.title, burl: "#{Generator.underscore(grpname)}##{ent.name}", level: 2
                    end
                end
                FileUtils.mkpath "#{@output}/_data/"
                File.open("#{@output}/_data/sidebar.yml", "w") {|f| f << Jekyll.navbar(@config, nav_group) }
            end

            def self.jekyll_build
                Ajd2jkl.verbose_say 'Launch jekyll build...'
                IO.pipe do |read_pipe, write_pipe|
                    fork do
                        `cd #{@output} && bundle exec jekyll build`
                    end
                    write_pipe.close
                    while line = read_pipe.gets
                        puts "Jekyll: #{line}"
                    end
                end
                Ajd2jkl.say_error 'Error during jekyll creation' && exit(1) unless $?.exitstatus.zero?
            end

            def self.gemfile
                # `echo "gem 'jekyll-theme-hydejack', '~> 6.0'" >> #{@output}/Gemfile`
                `cd #{@output} && bundle install`
            end

            def self.extra_docs
                return unless @config.key?('header') || @config.key?('footer')
                FileUtils.mkpath "#{@output}/_documentations/"
                base_dir = File.expand_path File.dirname @options.config
                FileUtils.cp "#{base_dir}/#{@config['header']['filename']}", "#{@output}/_documentations/#{File.basename @config['header']['filename']}" if @config.key?('header') && @config['header'].key?('filename')
                FileUtils.cp "#{base_dir}/#{@config['footer']['filename']}", "#{@output}/_documentations/#{File.basename @config['footer']['filename']}" if @config.key?('footer') && @config['footer'].key?('filename')
            end

            def self.images
                FileUtils.copy_entry File.expand_path(@options.imgs), "#{@output}/images", false, false, true if @options.imgs
            end

            def self.clean
                FileUtils.remove_dir @output
            end
        end
    end
end