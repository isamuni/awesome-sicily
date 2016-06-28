require 'yaml'
require 'erb'
require 'redcarpet'

markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

descfile_it = File.read("header_it.md")
descfile_en = File.read("header_en.md")

desc_it = markdown.render(descfile_it)
desc_en = markdown.render(descfile_en)

categories = YAML.load_file "list.yaml"
categories_en = {}

translation = {
  "Tecnologia" => "Tecnology",
  "Città, Ambiente e Legalità" => "City, Environment and Legality",
  "Giornalismo" => "Journalism",
  "Cultura" => "Culture"
  }

categories.each do |cat, cities|
  categories_en[ translation[cat] ] = cities
end

class PageRenderer
  def initialize(description, categories)
    @categories = categories
    @description = description
  end
  def render
    template = File.read("template.html.erb")
    ERB.new(template).result(binding)
  end
end


html_it = PageRenderer.new( desc_it, categories).render()
html_en = PageRenderer.new( desc_en, categories_en).render()

File.write('index.html', html_it)
File.write('index_en.html', html_en)
