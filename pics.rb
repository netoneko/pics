
require "rubygems"
require "bundler/setup"
require 'rvg/rvg'
require 'coderay'

tokens = CodeRay.scan File.read(__FILE__), :ruby
puts tokens.inspect
puts tokens.statistic


Magick::RVG::dpi = 90

fill = {
  content: "darkgrey",
  delimiter: 'darkgrey',
  operator: 'green',
  ident: 'black',
  symbol: 'magenta',
  instance_variable: 'pink',
  keyword: 'red',
  constant: 'pink'
}

rvg = Magick::RVG.new(30.cm, 30.cm).viewbox(0,0, 1200, 1200) do |canvas|
  canvas.background_fill = 'white'
  canvas.desc = "Example tspan02 - using tspan's dx and dy attributes for incremental positioning adjustments"
  canvas.g.styles(:font_family=>'Lucida Console', :font_size=> 15) do |_g|
    top_index = 0

    tokens.each_with_index do |token, index|
      puts token.inspect

      if token.kind_of? String
        @value = token
      elsif @value
        if (token == :space && @value == "\n") || !defined?(@text)
          @text = _g.text(10, (top_index += 1) * 25, @value.to_s).styles(:fill => fill[token] || 'black')
          puts "NEWLINE"
        else
          @text.tspan(@value.to_s).d(@value.size * 0.5, 0).styles(:fill => fill[token] || 'black')
        end

        @value = nil
      end
    end
  end
end

rvg.draw.write('pic.png')