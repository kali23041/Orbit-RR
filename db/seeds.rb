puts "Seeding Orbit..."

skills = [
  "Ruby on Rails",
  "System Design",
  "PostgreSQL",
  "Hotwire",
  "Career Coaching",
  "Interview Prep"
].map { |name| Skill.find_or_create_by!(name: name) }

mentors = [
  {
    email: "ava@orbit.dev",
    name: "Ava Chen",
    headline: "Staff Rails engineer · API design & Hotwire",
    bio: "I help mid-level engineers ship cleaner Rails apps: boundaries, background jobs, and Hotwire UX that feels instant.",
    rate: 9000,
    skill_names: [ "Ruby on Rails", "Hotwire", "PostgreSQL" ],
    years: 10
  },
  {
    email: "marcus@orbit.dev",
    name: "Marcus Cole",
    headline: "System design for product engineers",
    bio: "Ex-fintech. We will sketch trade-offs, failure modes, and a practical architecture you can defend in interviews.",
    rate: 12000,
    skill_names: [ "System Design", "Interview Prep", "PostgreSQL" ],
    years: 12
  },
  {
    email: "priya@orbit.dev",
    name: "Priya Nair",
    headline: "Career coaching for backend developers",
    bio: "Resume narrative, portfolio projects, and mock behavioral loops focused on Rails roles.",
    rate: 7000,
    skill_names: [ "Career Coaching", "Interview Prep", "Ruby on Rails" ],
    years: 8
  }
]

mentors.each_with_index do |data, index|
  user = User.find_or_initialize_by(email: data[:email])
  user.assign_attributes(
    firebase_uid: "seed-mentor-#{index + 1}",
    name: data[:name],
    role: :mentor,
    timezone: "UTC"
  )
  user.save!

  profile = MentorProfile.find_or_initialize_by(user: user)
  profile.assign_attributes(
    headline: data[:headline],
    bio: data[:bio],
    hourly_rate_cents: data[:rate],
    currency: "usd",
    active: true,
    years_experience: data[:years]
  )
  profile.save!
  profile.skills = skills.select { |skill| data[:skill_names].include?(skill.name) }

  next if profile.availability_slots.upcoming.exists?

  3.times do |offset|
    starts = (offset + 1).days.from_now.change(hour: 15 + offset, min: 0, sec: 0)
    profile.availability_slots.create!(
      starts_at: starts,
      ends_at: starts + 45.minutes,
      status: :open
    )
  end
end

learner = User.find_or_initialize_by(email: "learner@orbit.dev")
learner.assign_attributes(
  firebase_uid: "seed-learner-1",
  name: "Jordan Lee",
  role: :learner,
  timezone: "UTC"
)
learner.save!

admin = User.find_or_initialize_by(email: "admin@orbit.dev")
admin.assign_attributes(
  firebase_uid: "seed-admin-1",
  name: "Orbit Admin",
  role: :admin,
  timezone: "UTC"
)
admin.save!

puts "Done. Mentors: #{MentorProfile.count}, Skills: #{Skill.count}, Learner: #{learner.email}, Admin: #{admin.email}"
