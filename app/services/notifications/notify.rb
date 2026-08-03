# frozen_string_literal: true

module Notifications
  class Notify
    def self.call(user:, kind:, title:, body: nil, link_path: nil)
      user.notifications.create!(
        kind: kind,
        title: title,
        body: body,
        link_path: link_path
      )
    end
  end
end
