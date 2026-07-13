#!/usr/bin/env ruby
# WCAG contrast checks for core Solaris Nexus theme token pairs.

css = File.read(File.expand_path("../app/styles.css", __dir__), encoding: "UTF-8")
dark_block = css[/\A:root \{(.*?)\n\}/m, 1]
light_block = css[/:root\[data-theme="light"\] \{(.*?)\n\}/m, 1]

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

dark = variables(dark_block)
light = variables(light_block)
pairs = {
  "dark body text" => [dark["text"], dark["page-bg"]],
  "dark muted text" => [dark["text-muted"], dark["page-bg"]],
  "dark interactive text" => [dark["interactive-text"], dark["interactive-bg"]],
  "light body text" => [light["text"], light["page-bg"]],
  "light muted text" => [light["text-muted"], light["page-bg"]],
  "light interactive text" => [light["interactive-text"], light["interactive-bg"]],
  "light success badge" => [light["badge-ok-text"], light["badge-ok-bg"]],
  "light warning badge" => [light["badge-watch-text"], light["badge-watch-bg"]],
  "light action badge" => [light["badge-act-text"], light["badge-act-bg"]]
}

failures = pairs.map do |label, (foreground, background)|
  ratio = contrast(foreground, background)
  "#{label}: #{ratio.round(2)}:1" if ratio < 4.5
end.compact

unless failures.empty?
  failures.each { |failure| warn "FAIL: #{failure}" }
  exit 1
end

puts "PASS: core theme contrast pairs meet WCAG AA normal-text target"
pairs.each { |label, colors| puts "  #{label}: #{contrast(*colors).round(2)}:1" }
