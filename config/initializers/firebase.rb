# frozen_string_literal: true

Rails.application.configure do
  config.x.firebase.project_id = ENV.fetch("FIREBASE_PROJECT_ID", "")
  config.x.firebase.client_config = {
    apiKey: ENV.fetch("FIREBASE_API_KEY", ""),
    authDomain: ENV.fetch("FIREBASE_AUTH_DOMAIN", ""),
    projectId: ENV.fetch("FIREBASE_PROJECT_ID", ""),
    storageBucket: ENV.fetch("FIREBASE_STORAGE_BUCKET", ""),
    messagingSenderId: ENV.fetch("FIREBASE_MESSAGING_SENDER_ID", ""),
    appId: ENV.fetch("FIREBASE_APP_ID", ""),
    measurementId: ENV.fetch("FIREBASE_MEASUREMENT_ID", ""),
    databaseURL: ENV.fetch("FIREBASE_DATABASE_URL", "")
  }.freeze
end
