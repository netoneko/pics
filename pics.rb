
require "rubygems"
require "bundler/setup"
require 'rvg/rvg'
require 'coderay'

lines = File.readlines(__FILE__)
tokens = CodeRay.scan lines.join, :ruby
puts tokens.inspect
puts tokens.statistic
puts lines.count

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

rvg = Magick::RVG.new(1000, lines.size * 25) do |canvas|
  canvas.background_fill = 'white'
  canvas.desc = "Example tspan02 - using tspan's dx and dy attributes for incremental positioning adjustments"
  canvas.g.styles(:font_family=>'Lucida Console', :font_size=> 15) do |_g|
    top_index = 0

    tokens.each do |token|
      if token.kind_of? String
        @value = token
      elsif @value
        if (token == :space && @value == "\n") || !defined?(@text)
          @text = _g.text(10, (top_index += 1) * 25, @value.to_s).styles(:fill => fill[token] || 'black')
        else
          @text.tspan(@value.to_s).d(0, 0).styles(:fill => fill[token] || 'black')
        end

        @value = nil
      end
    end
  end
end

rvg.draw.write('pic.png')