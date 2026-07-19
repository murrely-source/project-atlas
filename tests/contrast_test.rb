#!/usr/bin/env ruby
# WCAG contrast checks for Solaris Lucerna public design tokens.

css = File.read(File.expand_path("../app/site.css", __dir__), encoding: "UTF-8")
root_block = css[/\A:root \{(.*?)\n\}/m, 1]

def variables(block)
  block.scan(/--([\w-]+):\s*(#[0-9a-f]{6});/i).to_h
end

def luminance(hex)
  channels = hex.delete_prefix("#").scan(/../).map { |value| value.to_i(16) / 255.0 }
  linear = channels.map { |value| value <= 0.04045 ? value / 12.92 : ((value + 0.055) / 1.055)**2.4 }
  0.2126 * linear[0] + 0.7152 * linear[1] + 0.0722 * linear[2]
end

def contrast(first, second)
  values = [luminance(first), luminance(second)].sort.reverse
  (values[0] + 0.05) / (values[1] + 0.05)
end

def blend(foreground, background, alpha)
  foreground_channels = foreground.delete_prefix("#").scan(/../).map { |value| value.to_i(16) }
  background_channels = background.delete_prefix("#").scan(/../).map { |value| value.to_i(16) }
  channels = foreground_channels.zip(background_channels).map do |front, back|
    (front * alpha + back * (1 - alpha)).round
  end
  "##{channels.map { |value| value.to_s(16).rjust(2, "0") }.join}"
end

tokens = variables(root_block)
pairs = {
  "dark body text" => [tokens["text"], tokens["midnight"]],
  "dark muted text" => [tokens["text-muted"], tokens["midnight"]],
  "cyan supporting text" => [tokens["cyan-soft"], tokens["midnight"]],
  "hero supporting text over worst-case shaded artwork" => ["#c5cdd7", blend("#000310", "#ffffff", 0.73)],
  "gold button text" => ["#1a1106", tokens["gold"]],
  "light-section body text" => ["#536271", tokens["white"]],
  "light-section heading" => [tokens["midnight"], tokens["white"]],
  "light status text" => [tokens["solaris-blue"], "#ffffff"],
  "mobile navigation text" => ["#f4f7fa", "#03131f"],
  "mobile navigation label" => ["#9fdff2", "#03131f"],
  "mobile active text" => ["#ffffff", "#08283a"]
}

failures = pairs.map do |label, colors|
  ratio = contrast(*colors)
  "#{label}: #{ratio.round(2)}:1" if ratio < 4.5
end.compact

unless failures.empty?
  failures.each { |failure| warn "FAIL: #{failure}" }
  exit 1
end

puts "PASS: Solaris Lucerna core text pairs meet WCAG AA"
pairs.each { |label, colors| puts "  #{label}: #{contrast(*colors).round(2)}:1" }
