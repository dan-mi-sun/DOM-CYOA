require_relative 'helper'

class DomTest < Test::Unit::TestCase

	def setup
		@dom = Nokogiri::HTML(File.open("my_amazing_webpage.html"))
		@html = @dom.elements.first
		@head = @dom.elements.last.children.first
		@body = @dom.elements.last.children.last
	end

	def test_document_is_html_doctype
		assert_equal "html", @dom.children.first.name
	end

	def test_first_element_is_the_html_root
		assert_equal "html", @dom.elements.first.name
	end

	def test_html_has_a_head_and_a_body
		assert_equal 2, @html.children.length
		assert_equal "head", @html.children.first.name
		assert_equal "body", @html.children.last.name
	end

	def test_document_has_a_title
		assert_equal "My Amazing Webpage", @dom.title
  end

	def test_document_has_text_nodes_that_maintain_whitespace
		assert_equal 9, @body.children.length # Might not be what you expect!
		assert_equal true, @body.children.first.is_a?(Nokogiri::XML::Text)
		assert_equal "", @body.children.first.content.strip
  end

	def test_body_has_child_elements
		assert_equal 5, @body.elements.length
		assert_equal ["h1", "img", "p", "ul", "div"], @body.elements.map {|e| e.name }
  end

	def test_elements_has_content
		assert_equal "This is an amazing webpage", @body.elements[0].content
		assert_equal "", @body.elements[1].content
  end

	def test_elements_have_sub_elements
		@ul = @body.elements[3]
		assert_equal 3, @ul.elements.length
		assert_equal "Interesting fact", @ul.elements[0].content
		assert_equal "Hard-hitting point", @ul.elements[1].content
		assert_equal "Superb insight", @ul.elements[2].content
  end


	def test_elements_can_have_attributes
		@img = @body.elements[1]
		assert_equal 2, @img.attributes.length
		assert_equal ["src", "alt"], @img.attributes.keys
    assert_equal "img/ulysses31_crew.jpg", @img.attr(:src)
		assert_equal "Ulysses 31", @img.attr(:alt)
  end

	def test_elements_can_be_found_by_id
		content = @dom.css('#content').first
		assert_equal "div", content.name
		assert_equal 2, content.elements.length
	end

	def test_elements_can_be_found_by_class
		facts = @dom.css('.fact')
		assert_equal 3, facts.length
		assert_equal "fact", facts.first.attr(:class)
		assert_equal "Interesting fact", facts.first.content
  end

	def test_dom_can_be_changed
		@img = @body.elements[1]
		@img.set_attribute("src", "http://placekitten.com/200/300")
		@img.set_attribute("alt", "Now I am a kitten")
    assert_equal "http://placekitten.com/200/300", @img.attr(:src)
		assert_equal "Now I am a kitten", @img.attr(:alt)
	end

	def test_dom_can_have_elements_added
		fun_fact = Nokogiri::XML::Node.new("li", @dom)
		fun_fact.content = "I rode an elephant when I was 5"
		@ul = @body.elements[3]
		@ul.add_child(fun_fact)

		assert_equal 4, @ul.elements.length
    assert_equal "I rode an elephant when I was 5", @ul.elements.last.content
	end

	def test_dom_elements_can_be_moved
		lead = @dom.css('.lead').first
		lead.parent = @body
		assert_equal 6, @body.elements.length
		assert_equal ["h1", "img", "p", "ul", "div", "p"], @body.elements.map {|e| e.name }
	end

end

