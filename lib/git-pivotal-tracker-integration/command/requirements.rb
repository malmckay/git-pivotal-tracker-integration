require 'git-pivotal-tracker-integration/command/base'
require 'git-pivotal-tracker-integration/command/command'
require 'git-pivotal-tracker-integration/util/git'

class GitPivotalTrackerIntegration::Command::Requirements < GitPivotalTrackerIntegration::Command::Base

  # Displays a Pivotal Tracker story
  #
  # @return [void]
  def run(argument)
    story = @configuration.story(@project)

    puts "-" * 80
    puts ' ' + story.name.bold.cyan
    puts "-" * 80

    s = {
      story.current_state.upcase => story.story_type,
      'Est' => story.estimate,
      'Req' => story.requested_by,
      'Own' => story.owned_by,
      'Id'  => story.id,
    }.map do |k,v|
      "#{k.white}: #{v.to_s.green}" if v
    end.compact.join(' | ')
    puts s

    # puts "#{} #{story.story_type} | #{story.estimate} | Req: #{story.requested_by} | Owns: #{story.owned_by} | Id: #{story.id}".white
    puts " Labels: #{story.labels}".white if story.labels
    puts "-" * 80
    puts (story.description||'<no description>')
    PivotalTracker::Note.all(story).each do |note|
      puts "#{note.noted_at}: #{note.author}"
      puts note.text
    end

  end

end
