class Notifier
  DEFAULT_TITLE = "Slack Alert"

  def self.notify(message, title: DEFAULT_TITLE)
    system('osascript', '-e', %Q{display notification "#{message}" with title "#{title}"})
  end
end
