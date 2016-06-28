# This script builds the hash containing the list from the markdown readme, and exports it in a pre-parsed yaml file. It can be used to transition between md and yaml, or to rendere directly from the markdown

md = File.read("README.md")
ls = md.split("\n")

# The parser will build $res starting from the markdown
$res = {}
$last_h2 = ""
$last_h3 = ""

def process_line_dict(line)
  line.strip!

  if line.start_with? "###"
    $last_h3 = line.sub("###", "").strip
    nil
  elsif line.start_with? "##"
    $last_h2 = line.sub("##", "").strip
    nil
  elsif line.start_with? "* "
    content = line.sub("* ", "").strip
    begin
    name, links = content.split(" - ")
    obj = { 'name' => name
    }
    #parse links
    regex = /\[([\w\s]+)\]\(([\w:.\/\-]+)\)/
    links.scan(regex).each do |ltxt, ll|
      obj[ltxt] = ll
    end
    $res[$last_h2] ||= {}
    $res[$last_h2][$last_h3] ||= []
    $res[$last_h2][$last_h3] << obj
  rescue
    puts "unable to parse" + content
  end
  end
end

ls.each do |line|
  process_line_dict line
end

# YAML output
# from this we can simply YAML.load()
print YAML.dump($res)
