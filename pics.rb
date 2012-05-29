
require "rubygems"
require "bundler/setup"
require 'rvg/rvg'
require 'coderay'

lines = File.readlines(__FILE__)
tokens = CodeRay.scan lines.join, :ruby

puts lines.count
puts tokens.statistic

fill = {
  content: "darkgrey",
  delimiter: 'darkgrey',
  operator: 'green',
  ident: 'orange',
  symbol: 'magenta',
  instance_variable: 'pink',
  keyword: 'red',
  constant: 'pink'
}

FontSize = 20
DoubleFontSize = FontSize * 2
DefaultColor = 'white'

rvg = Magick::RVG.new(lines.max_by(&:size).size * FontSize * 0.75, lines.size * DoubleFontSize) do |canvas|
  canvas.background_fill = 'black'
  canvas.desc = "Example tspan02 - using tspan's dx and dy attributes for incremental positioning adjustments"
  canvas.g.styles(font_family: 'Monaco', font_size: FontSize, font_weight: 'bold', fill: DefaultColor) do |_g|
    top_index = 0

    tokens.each do |token|
      if token.kind_of? String
        @value = token
      elsif @value
        if (token == :space && @value == "\n") || !defined?(@text)
          @text = _g.text(10, (top_index += 1) * DoubleFontSize, @value.to_s).styles(:fill => fill[token] || DefaultColor)
        else
          @text.tspan(@value.to_s).d(5, 0).styles(:fill => fill[token] || DefaultColor)
        end

        @value = nil
      end
    end
  end
end

rvg.draw.spread(0.05).write('pic.png')