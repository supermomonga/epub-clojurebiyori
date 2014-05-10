# coding: utf-8

require 'bundler'
Bundler.require


class App < Thor

  desc 'convert', 'convert ClojureBiyori into epub.'
  def convert
    renderer = Redcarpet::Render::XHTML.new({
      autolink: true,
      fenced_code: true,
      fenced_code_blocks: true,
      gh_blockcode: true,
      hard_wrap: true,
      lax_html_blocks: true,
      no_intra_emphasis: true,
      no_intraemphasis: true,
      space_after_headers: true,
      strikethrough: true,
      superscript: true,
      tables: true,
      xhtml: true
    })
    md = Redcarpet::Markdown.new(renderer, extensions = {})

    # List all markdowns
    readme_indices = Dir.glob('source/README.markdown')
    main_indices = Dir.glob('source/docs/*.markdown')
    sun_indices = Dir.glob('source/docs/sun/*.markdown')
    essay_indices = Dir.glob('source/essay/*.markdown')
    appendix_indices = Dir.glob('source/appendix/*.markdown')

    markdown_indices =
      readme_indices +
      main_indices +
      sun_indices +
      essay_indices +
      appendix_indices

    xhtml_indices = markdown_indices.map{|f|
      File.join 'processing', f.gsub('/', '_').sub('.markdown', '.xhtml')
    }

    # Convert markdown into html
    markdown_indices.zip(xhtml_indices) do |file_md, file_xhtml|
      xhtml_body = md.render File.open(file_md, 'r').read
      xhtml_source = <<-EOS
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
</head>
<body>
#{xhtml_body}
</body>
</html>
      EOS
      File.open(file_xhtml, 'w').write xhtml_source
    end

    # Convert html into epub
    builder = GEPUB::Builder.new do
      language 'ja'
      unique_identifier 'https://github.com/esehara/ClojureBiyori', 'ClojureBiyori', 'https://github.com/esehara/ClojureBiyori'
      title 'ClojureBiyori'
      creator 'esehara'

      resources(workdir: 'processing/') do
        ordered do
          xhtml_indices.each do |file_xhtml|
            file file_xhtml.sub('processing/', '')
          end
        end
      end
    end

    file_epub = File.join __dir__, 'build', 'ClojureBiyori.epub'
    builder.generate_epub file_epub

  end

  desc 'fetch', 'fetch ClojureBiyori source files.'
  def fetch
    source_dir = "#{__dir__}/source"
    if FileTest.exist? source_dir
      puts "Update source files."
      `cd #{source_dir}; git pull`
    else
      puts "Source files doesn't exist."
      `git clone git@github.com:esehara/ClojureBiyori.git #{source_dir}`
    end
  end

end

App.start ARGV
