#!/usr/bin/env ruby
# Primary navigation and consolidated workspace contracts.

root = File.expand_path("..", __dir__)
html = File.read(File.join(root, "app", "index.html"), encoding: "UTF-8")
data = File.read(File.join(root, "app", "data.js"), encoding: "UTF-8")
script = File.read(File.join(root, "app", "app.js"), encoding: "UTF-8")

expected_ids = %w[overview ask intelligence settings]
expected_labels = ["Overview", "Ask Nexus", "Intelligence Center", "Settings"]
nav_markup = html[/<nav aria-label="Solaris Nexus workspaces">(.*?)<\/nav>/m, 1]
abort("FAIL: primary workspace navigation is missing") unless nav_markup

nav_targets = nav_markup.scan(/data-page="([^"]+)"/).flatten
nav_labels = nav_markup.scan(/data-page="[^"]+">([^<]+)<\/button>/).flatten
workspace_ids = data.scan(/\{ id: "([^"]+)", label:/).flatten
workspace_labels = data.scan(/\{ id: "[^"]+", label: "([^"]+)" \}/).flatten

abort("FAIL: primary navigation routes changed: #{nav_targets.inspect}") unless nav_targets == expected_ids
abort("FAIL: primary navigation labels changed: #{nav_labels.inspect}") unless nav_labels == expected_labels
abort("FAIL: structured workspaces do not match the four primary routes") unless workspace_ids == expected_ids && workspace_labels == expected_labels
expected_ids.each do |id|
  abort("FAIL: missing primary page #{id}") unless html.include?(%(<section id="#{id}" class="page))
end

obsolete_labels = ["News Desk", "Standards &amp; Learning", "Regulatory Watch", "Decision Log", "Prompts", "Atlas Backlog", "Board Queue", "DHF / Decisions", "Skills Library", "Notifications", "Human Firewall™", "Progress & Milestones", "Documents"]
obsolete_labels.each do |label|
  abort("FAIL: obsolete primary navigation label remains: #{label}") if nav_markup.include?(label)
end

abort("FAIL: Ask Nexus prompt is missing") unless html.include?('id="ask-nexus-form"') && html.include?('id="ask-nexus-input"')
abort("FAIL: Ask Nexus invents connected behavior") unless script.include?("Model connectivity is not implemented in this preview. No prompt was sent.")
abort("FAIL: Overview contains a new-conversation control") if html.match?(/<section id="overview".*?Start New Conversation/m)
abort("FAIL: Overview separates reminders from notifications") if html.match?(/<section id="overview".*?<h3[^>]*>Reminders<\/h3>/m)
abort("FAIL: notifications remain a primary route") if nav_targets.include?("notifications")
abort("FAIL: legacy governed workspace content was deleted") unless %w[news human standards regulation progress backlog documents pending dhf skills notifications].all? { |id| html.include?(%(<section id="#{id}" class="page)) }

puts "PASS: Solaris Nexus primary navigation"
puts "  four routes in approved order; legacy workspace content retained without primary routes"
