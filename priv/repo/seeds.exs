# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BenarID.Repo.insert!(%BenarID.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Logger.configure level: :warn

alias BenarID.Schema.Member

num_members = 5000

for i <- 1..num_members do
  member = Member.changeset %Member{}, %{
    name: "Dummy Member #{i}",
    email: "dummymember#{i}@email.com",
  }
  BenarID.Repo.insert! member, on_conflict: :nothing
end
IO.puts "Successfully inserted #{num_members} members"
